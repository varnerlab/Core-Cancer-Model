include("Types.jl")
include("Patterns.jl")
include("Compiler.jl")

function find_index_of_species(list_of_species,species_symbol)

    # how many items do we have?
    number_of_items = length(list_of_species)

    location = -1
    counter = 1
    is_ok_to_stop = false
    while (is_ok_to_stop == false)

        # get symbol =
        test_symbol = list_of_species[counter]
        if (test_symbol == species_symbol)
            is_ok_to_stop = true
            location = counter
        else

            if (counter>=number_of_items)
                is_ok_to_stop = true
            end

            counter = counter + 1
        end
    end

    return location
end

function generate_code_from_ast(ast_node,code_array,list_of_species,visted_node_set)

    # mark ast_root_node as visted -
    push!(visted_node_set,ast_node)

    if (ast_node.node_type == :AND || ast_node.node_type == :OR)

        logical_node = 0
        if (ast_node.node_type == :AND)
            logical_node = JuliaNode(" minimum")
        else
            logical_node = JuliaNode(" maximum")
        end

        push!(code_array,logical_node)
        push!(code_array,JuliaNode("("))
        push!(code_array,JuliaNode("["))

        # process my kids -
        # get the kids of the current root node -
        children_array = ast_node.children_array
        for child_node in children_array
            if (in(child_node,visted_node_set) == false)
                generate_code_from_ast(child_node,code_array,list_of_species,visted_node_set)
            end
        end

        push!(code_array,JuliaNode("]"))
        push!(code_array,JuliaNode(")"))

    elseif (ast_node.node_type == :GENE_SYMBOL)

        # ok - find the index of the species -
        test_key = ast_node.lexeme
        species_index = find_index_of_species(list_of_species,test_key)

        # if gene symbol -
        gene_symbol_node = JuliaNode(" state_array[$(species_index)] ")

        # push onto the code stack -
        push!(code_array,gene_symbol_node)
    else
        children_array = ast_node.children_array
        for child_node in children_array
            if (in(child_node,visted_node_set) == false)
                generate_code_from_ast(child_node,code_array,list_of_species,visted_node_set)
            end
        end
    end
end

function recursive_build_ast_tree(sentence,rule_index)

    # build a root node -
    root_node = ASTNode()
    root_node.lexeme = "root_node"
    root_node.node_type = :ROOT_NODE
    root_node.children_array = ASTNode[]

    # need to classify this sentence -
    if (length(sentence) == 2)

        # this is a single node + stop
        node = recursive_build_direct_relationship!(sentence,root_node)
        push!(root_node.children_array,node)
        return root_node

    elseif (scan_all_or_logic(copy(sentence)) == true || scan_all_and_logic(copy(sentence)) == true)

        node = recursive_build_two_component_logical_relationship!(sentence,root_node)
        push!(root_node.children_array,node)
        return root_node

    elseif (scan_single_logical_trailing_clause(copy(sentence),0) == true)

        node = recursive_build_single_logical_trailing_statement!(sentence,root_node)
        push!(root_node.children_array,node)
        return root_node

    elseif (scan_single_logical_leading_clause(copy(sentence),0) == true)

        node = recursive_build_single_logical_leading_statement!(sentence,root_node)
        push!(root_node.children_array,node)
        return root_node

    elseif (scan_balanced_single_leading_trailing_clause(copy(sentence),0) == true)

        node = recursive_build_balanced_single_leading_trailing_statement!(sentence,root_node)
        push!(root_node.children_array,node)
        return root_node

    elseif (scan_muliple_nested_logical_clause_statement(copy(sentence),0) == true)

        node = recursive_long_and_connected_or_statement!(sentence,root_node)
        push!(root_node.children_array,node)
        return root_node

    elseif (scan_for_long_or_logic_trailing_and_clause(copy(sentence),0) == true)

        node = recursive_long_or_logic_trailing_and_statement!(sentence,root_node)
        push!(root_node.children_array,node)
        return root_node

    elseif (rule_index == 257) # NOTE: this is a f*ing hack to get this going ... we need to write the pattern routine

        node = recursive_multiple_leading_and_multiple_or_statement!(sentence,root_node)
        push!(root_node.children_array,node)
        return root_node

    elseif (rule_index == 259 || rule_index == 260 || rule_index == 261 || rule_index == 262 || rule_index == 263 || rule_index == 264)

        # ((4830.1 and 4831.1) or (4830.2 and 4831.1) or 4832.1 or 10201.1 or 29922.1 or 29922.2);
        node = recursive_multiple_leading_and_and_multiple_trailing_or_statement!(sentence,root_node)
        push!(root_node.children_array,node)
        return root_node

    elseif (rule_index == 274 || rule_index == 275)

        # (((593.1 and 594.1) and 1629.1 and 1738.1) or ((593.1 and 594.2) and 1629.1 and 1738.1));
        node = recursive_complex_and_single_centered_or_statement!(sentence,root_node)
        push!(root_node.children_array,node)
        return root_node

    elseif (rule_index == 286) # NOTE: this is a f*ing hack to get this going ... we need to write the pattern routine

        node = recursive_complex_multilevel_and_single_center_or_statement!(sentence,root_node)
        push!(root_node.children_array,node)
        return root_node

    elseif (rule_index == 35 || rule_index == 67 || rule_index == 273) # NOTE: this is a f*ing hack to get this going ... we need to write the pattern routine

        node = recursive_multilevel_and_single_center_or_statement!(sentence,root_node)
        push!(root_node.children_array,node)
        return root_node

    elseif (rule_index == 213 || rule_index == 267 || rule_index == 366) # NOTE: this is a f*ing hack to get this going ... we need to write the pattern routine

        node = recursive_long_and_connected_or_statement!(sentence,root_node)
        push!(root_node.children_array,node)
        return root_node

    elseif (rule_index == 367 || rule_index == 368) # NOTE: this is a f*ing hack to get this going ... we need to write the pattern routine

        node = recursive_long_and_leading_trailing_single_center_or_statement!(sentence,root_node)
        push!(root_node.children_array,node)
        return root_node

    else

        # ok, this the hard case - we have a "mixed" collection of AND/OR clauses -

    end

    # go -
    return nothing
end


function build_tokenized_sentence(rule_statement,token_type_dictionary)

    # initialize -
    char_stack = Char[]
    token_array = Token[]

    # turn statement into an array, and then reverse the order -
    local_statement_char_array = reverse(collect(rule_statement))
    while !isempty(local_statement_char_array)

        # pop -
        test_char = pop!(local_statement_char_array)
        if (test_char == '(')

            # ok, we have a LPAREN -
            push!(token_array,token_type_dictionary[string(hash("("))])

        elseif (test_char == ';')

            # ok, we have a space -
            if (length(char_stack)>0)

                # we have something on the stack - does it match one of our tokens?
                test_key = string(hash(join(char_stack)))
                if (haskey(token_type_dictionary,test_key) == true)

                    # Oh yeah ... we have a key - kia the stack -
                    empty!(char_stack)

                    # grab the token_instance -
                    token_instance = token_type_dictionary[test_key]

                    # push the instance onto the token_vector
                    push!(token_array,token_instance)
                else

                    # it's not a key, let's assume its a biological symbol -
                    # lexeme
                    lexeme = join(char_stack)

                    # We have chars in the stack, but not in our token_type_dictionary
                    token_instance = Token(lexeme,:GENE_SYMBOL)

                    # push the instance onto the token_vector
                    push!(token_array,token_instance)

                    # we have a key - kia the stack -
                    empty!(char_stack)
                end
            end

            # ok, we have a STOP -
            push!(token_array,token_type_dictionary[string(hash(";"))])

        elseif (test_char == ')')

            # ok, we have a space -
            if (length(char_stack)>0)

                # we have something on the stack - does it match one of our tokens?
                test_key = string(hash(join(char_stack)))
                if (haskey(token_type_dictionary,test_key) == true)

                    # Oh yeah ... we have a key - kia the stack -
                    empty!(char_stack)

                    # grab the token_instance -
                    token_instance = token_type_dictionary[test_key]

                    # push the instance onto the token_vector
                    push!(token_array,token_instance)
                else

                    # it's not a key, let's assume its a biological symbol -
                    # lexeme
                    lexeme = join(char_stack)

                    # We have chars in the stack, but not in our token_type_dictionary
                    token_instance = Token(lexeme,:GENE_SYMBOL)

                    # push the instance onto the token_vector
                    push!(token_array,token_instance)

                    # we have a key - kia the stack -
                    empty!(char_stack)
                end
            end

            # ok, we have a RPAREN -
            push!(token_array,token_type_dictionary[string(hash(")"))])

        elseif (test_char == ' ')

            # ok, we have a space -
            if (length(char_stack)>0)

                # we have something on the stack - does it match one of our tokens?
                test_key = string(hash(join(char_stack)))
                if (haskey(token_type_dictionary,test_key) == true)

                    # Oh yeah ... we have a key - kia the stack -
                    empty!(char_stack)

                    # grab the token_instance -
                    token_instance = token_type_dictionary[test_key]

                    # push the instance onto the token_vector
                    push!(token_array,token_instance)
                else

                    # it's not a key, let's assume its a biological symbol -
                    # lexeme
                    lexeme = join(char_stack)

                    # We have chars in the stack, but not in our token_type_dictionary
                    token_instance = Token(lexeme,:GENE_SYMBOL)

                    # push the instance onto the token_vector
                    push!(token_array,token_instance)

                    # we have a key - kia the stack -
                    empty!(char_stack)
                end
            end
        else

            # Cache the test_char
            push!(char_stack,test_char)

            # we do *not* have a stop char, build a test_key and check in the token_type_dictionary
            test_key = string(hash(join(char_stack)))
            if (haskey(token_type_dictionary,test_key) == true)

              # Oh yeah ... we have a key - kia the stack -
              empty!(char_stack)

              # grab the token_instance -
              token_instance = token_type_dictionary[test_key]

              # push the instance onto the token_vector
              push!(token_array,token_instance)
            end
        end
    end

    return Sentence(token_array)
end


# main -
function main(path_to_rules_file,path_to_cfl_file,number_of_reactions)

    # Setup the token dictionary (we could load this from a file ...)
    token_type_dictionary = Dict{String,Token}()
    token_type_dictionary[string(hash("("))] = Token("(",:LPAREN)
    token_type_dictionary[string(hash(")"))] = Token(")",:RPAREN)
    token_type_dictionary[string(hash("and"))] = Token("and",:AND)
    token_type_dictionary[string(hash("or"))] = Token("or",:OR)
    token_type_dictionary[string(hash(";"))] = Token(";",:STOP)
    token_type_dictionary[string(hash("GENE_SYMBOL"))] = Token("GENE_SYMBOL",:GENE_SYMBOL)
    token_type_dictionary[string(hash("CLAUSE"))] = Token("CLAUSE",:CLAUSE_STATEMENT)

    # initialize sentence_array -
    sentence_array = Sentence[]

    # initialize the array of ASTs -
    ast_array = ASTNode[]

    # initialize the code buffer -
    code_string_buffer = String[]

    # initialize the raw rule array -
    raw_rule_array = String[]
    raw_rule_index_array = String[]

    # load the rules file -
    open(path_to_rules_file) do f

        # this is a csv, so split around the comma -
        buffer = readstring(f)
        list_of_records = split(buffer,'\n')
        number_of_records = length(list_of_records)

        for record_index = 1:number_of_records

            # ok, the rule is the thrid entry -
            rule_text_array = split(list_of_records[record_index],',')
            if (length(rule_text_array) == 3)

                # Get the rule text -
                rule_text = string(rule_text_array[3])
                rule_index = string(rule_text_array[1])

                # cache for later -
                push!(raw_rule_array,rule_text)
                push!(raw_rule_index_array,rule_index)

                # parse the rule -
                sentence = build_tokenized_sentence(rule_text,token_type_dictionary)

                # add the tokenized sentence to the array -
                push!(sentence_array,sentence)
            end
        end
    end

    # we've got the tokenized sentence array, we need to create an AST for each sentence
    counter = 1
    for sentence in sentence_array

        rule_index = parse(Int,raw_rule_index_array[counter])

        # build up the AST, hand back the root node
        root_node = recursive_build_ast_tree(reverse(sentence.token_array),rule_index)
        if (root_node != nothing)
            # cache the root -
            push!(ast_array,root_node)
        else

            null_node = ASTNode()
            null_node.node_type = :NULL
            push!(ast_array,null_node)
        end

        counter = counter + 1
    end

    # how many rules do we have?
    number_of_rules = length(sentence_array)

    # generate a species list -
    list_of_transcripts = readdlm("../Transcripts.net",',')
    (number_of_transcripts,ncol) = size(list_of_transcripts)
    list_of_species = String[]
    for species_index = 1:number_of_transcripts

        # get transcript symbol -
        transcript_symbol = list_of_transcripts[species_index,2]

        # make the species name -
        species_tag = transcript_symbol[6:end]

        # cache -
        push!(list_of_species,species_tag)
    end


    # ok, finally - write the function w/the rules -
    push!(code_string_buffer,"function gene_association_rules(state_array,data_dictionary)")
    push!(code_string_buffer,"")
    push!(code_string_buffer,"\t # initialize the v array")
    push!(code_string_buffer,"\t v = zeros($(number_of_reactions))")
    push!(code_string_buffer,"")

    # generate code from the AST's
    visted_node_set = Set{ASTNode}()
    code_array = JuliaNode[]
    rule_counter = 1
    for ast_root in ast_array

        # raw information -
        raw_rule_text = raw_rule_array[rule_counter]
        raw_rule_index = raw_rule_index_array[rule_counter]

        local_buffer = ""
        if (ast_root.node_type != :NULL)

            # walk the tree -
            generate_code_from_ast(ast_root,code_array,list_of_species,visted_node_set)

            # fill the buffer -
            local_buffer *= "\t # $(raw_rule_index) -> $(raw_rule_text)\n"
            local_buffer *= "\t v[$(raw_rule_index)] = "
            for node in code_array

                # get the code fragment -
                code_fragment = node.node_text
                local_buffer *= code_fragment
            end
            push!(code_string_buffer,local_buffer)
            push!(code_string_buffer,"")
        else

            # we have a NULL node - something happened, we can't do this rule.
            local_buffer *= "\t # $(raw_rule_index) -> $(raw_rule_text)\n"
            local_buffer *= "\t v[$(raw_rule_index)] = -1.0"
            push!(code_string_buffer,local_buffer)
            push!(code_string_buffer,"")
        end

        # clear the visted set, and prepare for the next tree -
        empty!(visted_node_set)

        # empty the array -
        empty!(code_array)

        # update the rule counter -
        rule_counter = rule_counter + 1
    end

    push!(code_string_buffer,"")
    push!(code_string_buffer,"\t # return the varray to the caller - ")
    push!(code_string_buffer,"\t return v")
    push!(code_string_buffer,"end")


    # write to disk -
    open(path_to_cfl_file,"w") do f

        for statement in code_string_buffer
            write(f,"$(statement)\n")
        end
    end
end



# call to main -
main("./Network.rules","./Rules.jl",370)
