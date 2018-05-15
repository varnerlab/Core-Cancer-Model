function download_ec_number_from_kegg(gene_tag)

    # cutoff the G_
    gene_location = gene_tag[3:end]

    # get the sequence -
    ecdata = readstring(`curl -X GET http://rest.kegg.jp/link/ec/hsa:$(gene_location)`)

    # return this record -
    return ecdata
end

function download_gene_sequence_from_kegg(gene_tag)

    # cutoff the G_
    gene_location = gene_tag[3:end]

    # get the sequence -
    ntseq = readstring(`curl -X GET http://rest.kegg.jp/get/hsa:$(gene_location)/ntseq`)

    # remove the header -
    P = split(ntseq,'\n')

    # return the sequence -
    return P[3:end-1]
end

function download_protein_sequence_from_kegg(transcript_tag)

    # example -
    # mRNA_100.1

    # cutoff the G_
    mRNA_location = transcript_tag[6:end]
    mRNA_location = mRNA_location[1:end-2]

    @show mRNA_location

    # get the sequence -
    aaseq = readstring(`curl -X GET http://rest.kegg.jp/get/hsa:$(mRNA_location)/aaseq`)

    # remove the header -
    P = split(aaseq,'\n')

    # return the sequence -
    return P[3:end-1]
end

function write_ec_numbers_to_disk(path_to_input_file::String,path_to_output_file::String)

    # initalize -
    ec_number_buffer = String[]

    # get -
    gene_list = readdlm(path_to_input_file,',')

    # how many genes do we have?
    (number_of_genes,number_of_cols) = size(gene_list)

    # iterate through the list of tags -
    for gene_index = 1:number_of_genes

        # get the gene tag -
        gene_tag = gene_list[gene_index,2]

        # get the buffer -
        line_buffer = download_ec_number_from_kegg(gene_tag)

        # check - does this have multiple records?
        P = split(line_buffer,'\n')
        number_of_fragments = length(P)
        for fragment_index = 1:number_of_fragments

            fragment_string = string(P[fragment_index])
            if (length(fragment_string)>0)

                # add line to overall buffer -
                push!(ec_number_buffer,fragment_string)

                # message -
                msg = "$(gene_tag) => $(fragment_string) ($(gene_index) of $(number_of_genes))"
                println(msg)
            end
        end
    end

    # dump to disk -
    open("$(path_to_output_file)/ec_numbers.dat", "w") do f

        for line_item in ec_number_buffer
            write(f,"$(line_item)\n")
        end
    end
end

function write_protein_sequences_to_disk(path_to_input_file::String,path_to_output_file::String)

    # get -
    transcript_list = readdlm(path_to_input_file,',')

    # how many genes do we have?
    number_of_transcripts = length(transcript_list)

    # iterate through the list of tags -
    for transcript_index = 1:number_of_transcripts

        # get the gene tag -
        transcript_tag = transcript_list[transcript_index,2]
        mRNA_location = transcript_tag[6:end]
        mRNA_location = replace(mRNA_location,".","-")

        # get the buffer -
        buffer = download_protein_sequence_from_kegg(transcript_tag)

        # dump to disk -
        file_name = "$(path_to_output_file)/P_$(mRNA_location).seq"
        writedlm(file_name,buffer)
    end
end

function write_gene_sequences_to_disk(path_to_input_file::String,path_to_output_file::String)

    # get -
    gene_list = readdlm("Genes.net",',')

    # how many genes do we have?
    number_of_genes = length(gene_list)

    # iterate through the list of tags -
    for gene_index = 1:number_of_genes

        # get the gene tag -
        gene_tag = gene_list[gene_index,2]

        # get the buffer -
        buffer = download_gene_sequence_from_kegg(gene_tag)

        # dump to disk -
        file_name = "$(path_to_output_file)/$(gene_tag).seq"
        writedlm(file_name,buffer)
    end
end
