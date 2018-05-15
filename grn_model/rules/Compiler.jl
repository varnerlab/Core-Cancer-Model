
function ast_node_factory(token)

    # create a AND/OR -
    ast_node = ASTNode()
    ast_node.lexeme = token.lexeme
    ast_node.node_type = token.token_type
    ast_node.children_array = ASTNode[]

    return ast_node
end

# astree for:
# (((593.1 and 594.1) and 1629.1 and 1738.1) or ((593.1 and 594.2) and 1629.1 and 1738.1));
function recursive_complex_and_single_centered_or_statement!(sentence,root_node)

    # pop the next token from the sentence -
    next_token = pop!(sentence)
    if (next_token.token_type == :LPAREN)

        if (root_node.node_type == :LPAREN)

            # create clause -
            biological_symbol_token_1 = pop!(sentence)
            logical_token = pop!(sentence)
            biological_symbol_token_2 = pop!(sentence)

            # create logic/bio node -
            logic_node = ast_node_factory(logical_token)
            bio_node_1 = ast_node_factory(biological_symbol_token_1)
            bio_node_2 = ast_node_factory(biological_symbol_token_2)

            # add bionodes to logical node (create logic tree)
            push!(logic_node.children_array,bio_node_1)
            push!(logic_node.children_array,bio_node_2)

            # go down again, and pass the AND -
            return recursive_complex_and_single_centered_or_statement!(sentence,logic_node)
        elseif (root_node.node_type == :OR)

            # advance 1 (
            pop!(sentence)

            # create clause -
            biological_symbol_token_1 = pop!(sentence)
            logical_token = pop!(sentence)
            biological_symbol_token_2 = pop!(sentence)

            # create logic/bio node -
            logic_node = ast_node_factory(logical_token)
            bio_node_1 = ast_node_factory(biological_symbol_token_1)
            bio_node_2 = ast_node_factory(biological_symbol_token_2)

            # add bionodes to logical node (create logic tree)
            push!(logic_node.children_array,bio_node_1)
            push!(logic_node.children_array,bio_node_2)

            # advance 1 )
            pop!(sentence)

            # create an AND -
            and_node = ASTNode()
            and_node.lexeme = "and"
            and_node.node_type = :AND
            and_node.children_array = ASTNode[]

            # add -
            push!(and_node.children_array,logic_node)

            # initialize storage -
            gene_symbol_array = ASTNode[]

            # scan to the RPAREN -
            should_we_iterate = true
            while (should_we_iterate)

                # pop node from sentence -
                local_next_token = pop!(sentence)
                if (local_next_token.token_type == :GENE_SYMBOL)

                    # create a bionode -
                    bio_ast_node = ast_node_factory(local_next_token)

                    # cache -
                    push!(gene_symbol_array,bio_ast_node)

                elseif (local_next_token.token_type == :RPAREN)

                    # add all the nodes in gene symbol array to AND -
                    for node in gene_symbol_array
                        push!(and_node.children_array,node)
                    end

                    # stop!
                    should_we_iterate = false
                end
            end

            # add AND to root -
            push!(root_node.children_array,and_node)

            # go down again, pass the logic node -
            return recursive_complex_and_single_centered_or_statement!(sentence,root_node)
        else
            # advance 1 (
            pop!(sentence)

            # create a ( node
            lparen_node = ast_node_factory(next_token)
            return recursive_complex_and_single_centered_or_statement!(sentence,lparen_node)
        end

    elseif (next_token.token_type == :AND)

        if (root_node.node_type == :AND)

            # create AND, and add the root to it -
            logical_and_node = ast_node_factory(next_token)

            # add root -
            push!(logical_and_node.children_array,root_node)

            # initialize storage -
            gene_symbol_array = ASTNode[]

            # scan to the RPAREN -
            should_we_iterate = true
            while (should_we_iterate)

                # pop node from sentence -
                local_next_token = pop!(sentence)
                if (local_next_token.token_type == :GENE_SYMBOL)

                    # create a bionode -
                    bio_ast_node = ast_node_factory(local_next_token)

                    # cache -
                    push!(gene_symbol_array,bio_ast_node)

                elseif (local_next_token.token_type == :RPAREN)

                    # add all the nodes in gene symbol array to AND -
                    for node in gene_symbol_array
                        push!(logical_and_node.children_array,node)
                    end

                    # stop!
                    should_we_iterate = false
                end
            end

            # go down again ...
            return recursive_complex_and_single_centered_or_statement!(sentence,logical_and_node)
        end

    elseif (next_token.token_type == :OR)

        if (root_node.node_type == :AND)

            # build OR node -
            logical_or_node = ast_node_factory(next_token)

            # add root to the OR -
            push!(logical_or_node.children_array,root_node)

            # go down again -
            return recursive_complex_and_single_centered_or_statement!(sentence,logical_or_node)
        end
    elseif (next_token.token_type == :GENE_SYMBOL)

        if (root_node.node_type == :AND)
            bio_ast_node = ast_node_factory(next_token)
            push!(root_node.children_array,bio_ast_node)

            # go down again -
            return recursive_complex_and_single_centered_or_statement!(sentence,root_node)
        end

    elseif (next_token.token_type == :RPAREN)
        return recursive_complex_and_single_centered_or_statement!(sentence,root_node)
    elseif (next_token.token_type == :STOP)
        return root_node
    end

    # default: return nothing
    return nothing
end

# astree for:
# ((4830.1 and 4831.1) or (4830.2 and 4831.1) or 4832.1 or 10201.1 or 29922.1 or 29922.2);
function recursive_multiple_leading_and_and_multiple_trailing_or_statement!(sentence,root_node)

    # pop the next token from the sentence -
    next_token = pop!(sentence)
    if (next_token.token_type == :LPAREN)

        if (root_node.node_type == :LPAREN)

            # create clause -
            biological_symbol_token_1 = pop!(sentence)
            logical_token = pop!(sentence)
            biological_symbol_token_2 = pop!(sentence)

            # create logic/bio node -
            logic_node = ast_node_factory(logical_token)
            bio_node_1 = ast_node_factory(biological_symbol_token_1)
            bio_node_2 = ast_node_factory(biological_symbol_token_2)

            # add bionodes to logical node (create logic tree)
            push!(logic_node.children_array,bio_node_1)
            push!(logic_node.children_array,bio_node_2)

            # go down, pass this and -
            return recursive_multiple_leading_and_and_multiple_trailing_or_statement!(sentence,logic_node)
        elseif (root_node.node_type == :OR)


            # create clause -
            biological_symbol_token_1 = pop!(sentence)
            logical_token = pop!(sentence)
            biological_symbol_token_2 = pop!(sentence)

            # create logic/bio node -
            logic_node = ast_node_factory(logical_token)
            bio_node_1 = ast_node_factory(biological_symbol_token_1)
            bio_node_2 = ast_node_factory(biological_symbol_token_2)

            # add bionodes to logical node (create logic tree)
            push!(logic_node.children_array,bio_node_1)
            push!(logic_node.children_array,bio_node_2)

            # add to the OR -
            push!(root_node.children_array,logic_node)

            # go down again, pass the OR -
            return recursive_multiple_leading_and_and_multiple_trailing_or_statement!(sentence,root_node)
        else
            # create a ( node
            lparen_node = ast_node_factory(next_token)
            return recursive_multiple_leading_and_and_multiple_trailing_or_statement!(sentence,lparen_node)
        end
    elseif (next_token.token_type == :OR)

        if (root_node.node_type == :AND)

            # create or,
            logical_or_node = ast_node_factory(next_token)

            # add root to it -
            push!(logical_or_node.children_array,root_node)

            # go down again, pass the OR -
            return recursive_multiple_leading_and_and_multiple_trailing_or_statement!(sentence,logical_or_node)
        else
            # go down again, pass the OR -
            return recursive_multiple_leading_and_and_multiple_trailing_or_statement!(sentence,root_node)
        end
    elseif (next_token.token_type == :GENE_SYMBOL)
        if (root_node.node_type == :OR)
            # create biosymbol ast node -
            bio_ast_node = ast_node_factory(next_token)

            # add to OR -
            push!(root_node.children_array,bio_ast_node)

            # go down again - pass the OR -
            return recursive_multiple_leading_and_and_multiple_trailing_or_statement!(sentence,root_node)
        end
    elseif (next_token.token_type == :RPAREN)
        return recursive_multiple_leading_and_and_multiple_trailing_or_statement!(sentence,root_node)
    elseif (next_token.token_type == :STOP)
        return root_node
    end

    # default: return nothing
    return nothing
end

# astree for:
# ((1737.1 and (1738.1 and 8050.1) and (5161.1 and 5162.1)) or (1737.1 and (1738.1 and 8050.1) and (5160.1 and 5162.1)));
function recursive_complex_multilevel_and_single_center_or_statement!(sentence,root_node)

    # pop the next token from the sentence -
    next_token = pop!(sentence)
    if (next_token.token_type == :LPAREN)

        if (root_node.node_type == :LPAREN)

            # what is this node?
            local_next_node = pop!(sentence)

            # grab the bio_ast_node -
            bio_ast_node = ast_node_factory(local_next_node)

            # go down again, pass this node as root -
            return recursive_complex_multilevel_and_single_center_or_statement!(sentence,bio_ast_node)
        elseif (root_node.node_type == :AND)

            # create clause -
            biological_symbol_token_1 = pop!(sentence)
            logical_token = pop!(sentence)
            biological_symbol_token_2 = pop!(sentence)

            # create logic/bio node -
            logic_node = ast_node_factory(logical_token)
            bio_node_1 = ast_node_factory(biological_symbol_token_1)
            bio_node_2 = ast_node_factory(biological_symbol_token_2)

            # add bionodes to logical node (create logic tree)
            push!(logic_node.children_array,bio_node_1)
            push!(logic_node.children_array,bio_node_2)

            # add logic node to AND root -
            push!(root_node.children_array,logic_node)

            # go down again w/AND as root -
            return recursive_complex_multilevel_and_single_center_or_statement!(sentence,root_node)
        elseif (root_node.node_type == :OR)
            return recursive_complex_multilevel_and_single_center_or_statement!(sentence,root_node)
        else
            # create a ( node
            lparen_node = ast_node_factory(next_token)
            return recursive_complex_multilevel_and_single_center_or_statement!(sentence,lparen_node)
        end
    elseif (next_token.token_type == :AND)

        if (root_node.node_type == :GENE_SYMBOL)

            # create AND node, add gene symbol to it, pass as ROOT -
            logical_and_node = ast_node_factory(next_token)

            # add -
            push!(logical_and_node.children_array,root_node)

            # go down again ...
            return recursive_complex_multilevel_and_single_center_or_statement!(sentence,logical_and_node)
        elseif (root_node.node_type == :AND)

            # go down again ...
            return recursive_complex_multilevel_and_single_center_or_statement!(sentence,root_node)
        end
    elseif (next_token.token_type == :OR)

        # this is the highest of the high ...
        # create an OR node node, add root to the OR and pass OR as root -
        logical_or_node = ast_node_factory(next_token)

        # add -
        push!(logical_or_node.children_array,root_node)

        # go down again ...
        return recursive_complex_multilevel_and_single_center_or_statement!(sentence,logical_or_node)
    elseif (next_token.token_type == :GENE_SYMBOL)

        if (root_node.node_type == :OR)

            # create an AND node, and add it as my child, and also set the parent link -
            ast_and_node = ASTNode()
            ast_and_node.lexeme = "and"
            ast_and_node.node_type = :AND
            ast_and_node.children_array = ASTNode[]
            ast_and_node.parent = root_node

            # build gene symbol node -
            gene_symbol_node = ast_node_factory(next_token)

            # add the gene symbol to the AND -
            push!(ast_and_node.children_array,gene_symbol_node)

            # add the and to the OR -
            push!(root_node.children_array,ast_and_node)

            # pass the AND as the root down the chain ...
            return recursive_complex_multilevel_and_single_center_or_statement!(sentence,ast_and_node)
        end

    elseif (next_token.token_type == :RPAREN)
        return recursive_complex_multilevel_and_single_center_or_statement!(sentence,root_node)
    elseif (next_token.token_type == :STOP)
        return root_node.parent
    end

    # default: return nothing
    return nothing
end

# astree for:
# ((4830.1 and 4831.1) or (4830.2 and 4831.1) or 4832.1 or 29922.2 or 10201.1 or 29922.1);
function recursive_multiple_leading_and_multiple_or_statement!(sentence,root_node)

    # pop the next token from the sentence -
    next_token = pop!(sentence)
    if (next_token.token_type == :LPAREN)
        if (root_node.node_type == :LPAREN)

            # ok, so we have a clause -

            # create clause -
            biological_symbol_token_1 = pop!(sentence)
            logical_token = pop!(sentence)
            biological_symbol_token_2 = pop!(sentence)

            # create logic/bio node -
            logic_node = ast_node_factory(logical_token)
            bio_node_1 = ast_node_factory(biological_symbol_token_1)
            bio_node_2 = ast_node_factory(biological_symbol_token_2)

            # add bionodes to logical node (create logic tree)
            push!(logic_node.children_array,bio_node_1)
            push!(logic_node.children_array,bio_node_2)

            # go down again ...
            return recursive_multiple_leading_and_multiple_or_statement!(sentence,logic_node)
        elseif (root_node.node_type == :OR)

            # create clause -
            biological_symbol_token_1 = pop!(sentence)
            logical_token = pop!(sentence)
            biological_symbol_token_2 = pop!(sentence)

            # create logic/bio node -
            logic_node = ast_node_factory(logical_token)
            bio_node_1 = ast_node_factory(biological_symbol_token_1)
            bio_node_2 = ast_node_factory(biological_symbol_token_2)

            # add bionodes to logical node (create logic tree)
            push!(logic_node.children_array,bio_node_1)
            push!(logic_node.children_array,bio_node_2)

            # add this to the root node -
            push!(root_node.children_array,logic_node)

            # go down again ...
            return recursive_multiple_leading_and_multiple_or_statement!(sentence,root_node)
        else
            # create a ( node
            lparen_node = ast_node_factory(next_token)
            return recursive_multiple_leading_and_multiple_or_statement!(sentence,lparen_node)
        end
    elseif (next_token.token_type == :OR)

        if (root_node.node_type == :AND)

            # logical OR -
            logic_node = ast_node_factory(next_token)

            # add AND to the OR -
            push!(logic_node.children_array,root_node)

            # go down again -
            return recursive_multiple_leading_and_multiple_or_statement!(sentence,logic_node)
        elseif (root_node.node_type == :OR)

            # initialize -
            gene_symbol_array = ASTNode[]

            # scan to the RPAREN -
            should_we_iterate = true
            while (should_we_iterate)

                # pop node from sentence -
                local_next_token = pop!(sentence)
                if (local_next_token.token_type == :GENE_SYMBOL)
                    # create a bionode -
                    bio_ast_node = ast_node_factory(local_next_token)

                    # cache -
                    push!(gene_symbol_array,bio_ast_node)
                elseif (local_next_token.token_type == :RPAREN)

                    # add all the nodes in gene symbol array to AND -
                    for node in gene_symbol_array
                        push!(root_node.children_array,node)
                    end

                    # stop!
                    should_we_iterate = false
                end
            end

            # go down again ...
            return recursive_multiple_leading_and_multiple_or_statement!(sentence,root_node)
        end

    elseif (next_token.token_type == :RPAREN)
        return recursive_multiple_leading_and_multiple_or_statement!(sentence,root_node)
    elseif (next_token.token_type == :STOP)
        return root_node
    end

    # default: return nothing
    return nothing
end

# astree for:
# (((1738.1 and 8050.1) and 1743.1 and 4967.1) or ((1738.1 and 8050.1) and 1743.1 and 4967.2));
function recursive_multilevel_and_single_center_or_statement!(sentence,root_node)

    # pop the next token from the sentence -
    next_token = pop!(sentence)
    if (next_token.token_type == :LPAREN)
        if (root_node.node_type == :LPAREN)

            # ok, so I'm in the first AND clause -

            # create clause -
            biological_symbol_token_1 = pop!(sentence)
            logical_token = pop!(sentence)
            biological_symbol_token_2 = pop!(sentence)

            # create logic/bio node -
            logic_node = ast_node_factory(logical_token)
            bio_node_1 = ast_node_factory(biological_symbol_token_1)
            bio_node_2 = ast_node_factory(biological_symbol_token_2)

            # add bionodes to logical node (create logic tree)
            push!(logic_node.children_array,bio_node_1)
            push!(logic_node.children_array,bio_node_2)

            # now, go down again, but pass the logic node as root -
            return recursive_multilevel_and_single_center_or_statement!(sentence,logic_node)
        elseif (root_node.node_type == :OR)

            # iterate through the trailing clause -
            first_logical_and_node = 0
            second_logical_and_node = 0

            # initialize -
            gene_symbol_array = ASTNode[]

            # lets iterate until I hit the closing )
            should_we_iterate = true
            while (should_we_iterate)

                # pop node from sentence -
                local_next_token = pop!(sentence)
                if (local_next_token.token_type == :GENE_SYMBOL)
                    # create a bionode -
                    bio_ast_node = ast_node_factory(local_next_token)

                    # cache -
                    push!(gene_symbol_array,bio_ast_node)
                elseif (local_next_token.token_type == :AND && first_logical_and_node == 0)
                    first_logical_and_node = ast_node_factory(local_next_token)
                elseif (local_next_token.token_type == :RPAREN)

                    # add all the nodes in gene symbol array to AND -
                    for node in gene_symbol_array
                        push!(first_logical_and_node.children_array,node)
                    end

                    # stop!
                    should_we_iterate = false

                end
            end

            # empty the gene array -
            empty!(gene_symbol_array)

            # run through the remaining ANDs -
            should_we_iterate = true
            while (should_we_iterate)

                # pop node from sentence -
                local_next_token = pop!(sentence)
                if (local_next_token.token_type == :AND && second_logical_and_node == 0)
                    second_logical_and_node = ast_node_factory(local_next_token)
                elseif (local_next_token.token_type == :GENE_SYMBOL)
                    # create a bionode -
                    bio_ast_node = ast_node_factory(local_next_token)

                    # cache -
                    push!(gene_symbol_array,bio_ast_node)
                elseif (local_next_token.token_type == :RPAREN)

                    # add all the nodes in gene symbol array to AND -
                    for node in gene_symbol_array
                        push!(second_logical_and_node.children_array,node)
                    end

                    # add first AND -
                    push!(second_logical_and_node.children_array,first_logical_and_node)

                    # add second AND to root OR -
                    push!(root_node.children_array,second_logical_and_node)

                    # stop!
                    should_we_iterate = false
                end
            end

            return recursive_multilevel_and_single_center_or_statement!(sentence,root_node)
        else

            # hack ..
            next_token = pop!(sentence)

            # create a ( node
            lparen_node = ast_node_factory(next_token)
            return recursive_multilevel_and_single_center_or_statement!(sentence,lparen_node)
        end
    elseif (next_token.token_type == :OR)

        if (root_node.node_type == :AND)

            # create OR, and the and to the OR and then pass the OR -
            # ok, we have an AND clause -> add to me
            logical_or_node = ast_node_factory(next_token)

            # add -
            push!(logical_or_node.children_array,root_node)

            # go -
            return recursive_multilevel_and_single_center_or_statement!(sentence,logical_or_node)
        end

    elseif (next_token.token_type == :AND)
        if (root_node.node_type == :AND)

            # ok, so we need to scan until we hit )
            # initialize some storage -
            gene_symbol_array = ASTNode[]

            # all the nodes will be under an AND
            logical_and_node = 0

            # ok, so if we get here, then we have a variable length and clause -
            # lets iterate until I hit the closing )
            should_we_iterate = true
            while (should_we_iterate)

                # pop node from sentence -
                local_next_token = pop!(sentence)
                if (local_next_token.token_type == :GENE_SYMBOL)

                    # create a bionode -
                    bio_ast_node = ast_node_factory(local_next_token)

                    # cache -
                    push!(gene_symbol_array,bio_ast_node)
                elseif (local_next_token.token_type == :AND && logical_and_node == 0)
                    logical_and_node = ast_node_factory(local_next_token)
                elseif (local_next_token.token_type == :RPAREN)

                    # add all the nodes in gene symbol array to AND -
                    for node in gene_symbol_array
                        push!(logical_and_node.children_array,node)
                    end

                    # stop!
                    should_we_iterate = false
                end
            end

            # ok, add the root clause to the logical AND -
            push!(logical_and_node.children_array,root_node)

            # ok, so we should have processed this clause - pass the AND to the next step -
            return recursive_multilevel_and_single_center_or_statement!(sentence,logical_and_node)
        end

    elseif (next_token.token_type == :RPAREN)
        return recursive_multilevel_and_single_center_or_statement!(sentence,root_node)
    elseif (next_token.token_type == :STOP)
        return root_node
    end

    # default: return nothing
    return nothing
end

# astree for:
# ((55967.1 and 51079.1 ...) or
# (55967.1 and 51079.1 ...) or
# (55967.1 and 51079.1 ...) or
# (55967.1 and 51079.1 ...) or
# (55967.1 and 51079.1 ...) or
# (55967.1 and 51079.1 ...) or
# (55967.1 and 51079.1 ...) or
# (55967.1 and 51079.1 ...));
function recursive_long_and_connected_or_statement!(sentence,root_node)

    # pop the next token from the sentence -
    next_token = pop!(sentence)
    if (next_token.token_type == :LPAREN)

        if (root_node.node_type == :LPAREN)

            # initialize some storage -
            gene_symbol_array = ASTNode[]

            # all the nodes will be under an AND
            logical_and_node = 0

            # ok, so if we get here, then we have a variable length and clause -
            # lets iterate until I hit the closing )
            should_we_iterate = true
            while (should_we_iterate)

                # pop node from sentence -
                local_next_token = pop!(sentence)
                if (local_next_token.token_type == :GENE_SYMBOL)

                    # create a bionode -
                    bio_ast_node = ast_node_factory(local_next_token)

                    # cache -
                    push!(gene_symbol_array,bio_ast_node)
                elseif (local_next_token.token_type == :AND && logical_and_node == 0)
                    logical_and_node = ast_node_factory(local_next_token)
                elseif (local_next_token.token_type == :RPAREN)

                    # add all the nodes in gene symbol array to AND -
                    for node in gene_symbol_array
                        push!(logical_and_node.children_array,node)
                    end

                    # stop!
                    should_we_iterate = false
                end
            end

            # ok, so we should have processed this clause - pass the AND to the next step -
            return recursive_long_and_connected_or_statement!(sentence,logical_and_node)
        elseif (root_node.node_type == :OR)

            # scan again, add AND clause to OR -

            # initialize some storage -
            gene_symbol_array = ASTNode[]

            # all the nodes will be under an AND
            logical_and_node = 0

            # ok, so if we get here, then we have a variable length and clause -
            # lets iterate until I hit the closing )
            should_we_iterate = true
            while (should_we_iterate)

                # pop node from sentence -
                local_next_token = pop!(sentence)
                if (local_next_token.token_type == :GENE_SYMBOL)

                    # create a bionode -
                    bio_ast_node = ast_node_factory(local_next_token)

                    # cache -
                    push!(gene_symbol_array,bio_ast_node)
                elseif (local_next_token.token_type == :AND && logical_and_node == 0)
                    logical_and_node = ast_node_factory(local_next_token)
                elseif (local_next_token.token_type == :RPAREN)

                    # add all the nodes in gene symbol array to AND -
                    for node in gene_symbol_array
                        push!(logical_and_node.children_array,node)
                    end

                    # stop!
                    should_we_iterate = false
                end
            end

            # add AND to root -
            push!(root_node.children_array,logical_and_node)

            # go down again -
            return recursive_long_and_connected_or_statement!(sentence,root_node)
        else
            # create a ( node
            lparen_node = ast_node_factory(next_token)
            return recursive_long_and_connected_or_statement!(sentence,lparen_node)
        end

    elseif (next_token.token_type == :OR)

        if (root_node.node_type == :AND)

            # ok, we have an AND clause -> add to me
            logical_or_node = ast_node_factory(next_token)

            # add -
            push!(logical_or_node.children_array,root_node)

            # go down again w/OR as root -
            return recursive_long_and_connected_or_statement!(sentence,logical_or_node)
        elseif (root_node.node_type == :OR)
            return recursive_long_and_connected_or_statement!(sentence,root_node)
        end

    elseif (next_token.token_type == :RPAREN)
        return recursive_long_and_connected_or_statement!(sentence,root_node)
    elseif (next_token.token_type == :STOP)
        return root_node
    end

    # default: return nothing
    return nothing

end

# astree for:
# ((1537.1 and 4519.1 and 29796.2 and 27089.1 and 10975.1 and 7381.1 and 7384.1 and 7385.1 and 7386.1 and 7388.1) or
#   (1537.1 and 4519.1 and 29796.1 and 27089.1 and 10975.1 and 7381.1 and 7384.1 and 7385.1 and 7386.1 and 7388.1));
function recursive_long_and_leading_trailing_single_center_or_statement!(sentence,root_node)

    # pop the next token from the sentence -
    next_token = pop!(sentence)
    if (next_token.token_type == :LPAREN)

        if (root_node.node_type == :LPAREN)

            # initialize some storage -
            gene_symbol_array = ASTNode[]

            # all the nodes will be under an AND
            logical_and_node = 0

            # ok, so if we get here, then we have a variable length and clause -
            # lets iterate until I hit the closing )
            should_we_iterate = true
            while (should_we_iterate)

                # pop node from sentence -
                local_next_token = pop!(sentence)
                if (local_next_token.token_type == :GENE_SYMBOL)

                    # create a bionode -
                    bio_ast_node = ast_node_factory(local_next_token)

                    # cache -
                    push!(gene_symbol_array,bio_ast_node)
                elseif (local_next_token.token_type == :AND && logical_and_node == 0)
                    logical_and_node = ast_node_factory(local_next_token)
                elseif (local_next_token.token_type == :RPAREN)

                    # add all the nodes in gene symbol array to AND -
                    for node in gene_symbol_array
                        push!(logical_and_node.children_array,node)
                    end

                    # stop!
                    should_we_iterate = false
                end
            end

            # ok, so we should have processed this clause - pass the AND to the next step -
            return recursive_long_and_leading_trailing_single_center_or_statement!(sentence,logical_and_node)
        elseif (root_node.node_type == :OR)

            # scan again, add AND clause to OR -

            # initialize some storage -
            gene_symbol_array = ASTNode[]

            # all the nodes will be under an AND
            logical_and_node = 0

            # ok, so if we get here, then we have a variable length and clause -
            # lets iterate until I hit the closing )
            should_we_iterate = true
            while (should_we_iterate)

                # pop node from sentence -
                local_next_token = pop!(sentence)
                if (local_next_token.token_type == :GENE_SYMBOL)

                    # create a bionode -
                    bio_ast_node = ast_node_factory(local_next_token)

                    # cache -
                    push!(gene_symbol_array,bio_ast_node)
                elseif (local_next_token.token_type == :AND && logical_and_node == 0)
                    logical_and_node = ast_node_factory(local_next_token)
                elseif (local_next_token.token_type == :RPAREN)

                    # add all the nodes in gene symbol array to AND -
                    for node in gene_symbol_array
                        push!(logical_and_node.children_array,node)
                    end

                    # stop!
                    should_we_iterate = false
                end
            end

            # add AND to root -
            push!(root_node.children_array,logical_and_node)

            # go down again -
            return recursive_long_and_leading_trailing_single_center_or_statement!(sentence,root_node)
        else
            # create a ( node
            lparen_node = ast_node_factory(next_token)
            return recursive_long_and_leading_trailing_single_center_or_statement!(sentence,lparen_node)
        end

    elseif (next_token.token_type == :OR)

        if (root_node.node_type == :AND)

            # ok, we have an AND clause -> add to me
            logical_or_node = ast_node_factory(next_token)

            # add -
            push!(logical_or_node.children_array,root_node)

            # go down again w/OR as root -
            return recursive_long_and_leading_trailing_single_center_or_statement!(sentence,logical_or_node)
        end

    elseif (next_token.token_type == :RPAREN)
        return recursive_long_or_logic_trailing_and_statement!(sentence,root_node)
    elseif (next_token.token_type == :STOP)
        return root_node
    end

    # default: return nothing
    return nothing
end

# astree for:
# (3939.1 or 3945.1 or 3948.1 or 3948.2 or 92483.1 or 160287.1 or 55293.1 or (3939.1 and 3945.1)); 21
# (3939.1 or 3945.1 or 3948.1 or 3948.2 or 92483.1 or 160287.1 or 55293.1 or X or (3939.1 and 3945.1)); 23
# (3939.1 or 3945.1 or 3948.1 or 3948.2 or 92483.1 or 160287.1 or 55293.1 or X or Z or (3939.1 and 3945.1)); 25
function recursive_long_or_logic_trailing_and_statement!(sentence,root_node)

    # pop the next token from the sentence -
    next_token = pop!(sentence)
    if (next_token.token_type == :LPAREN)

        if (root_node.node_type == :OR)

            # ok, so if we get here - we are in a clause
            # create clause -
            biological_symbol_token_1 = pop!(sentence)
            logical_token = pop!(sentence)
            biological_symbol_token_2 = pop!(sentence)

            # create logic/bio node -
            logic_node = ast_node_factory(logical_token)
            bio_node_1 = ast_node_factory(biological_symbol_token_1)
            bio_node_2 = ast_node_factory(biological_symbol_token_2)

            # add bionodes to logical node (create logic tree)
            push!(logic_node.children_array,bio_node_1)
            push!(logic_node.children_array,bio_node_2)

            # add clause to root -
            push!(root_node.children_array,logic_node)

            # now, go down again, but pass the logic node as root -
            return recursive_long_or_logic_trailing_and_statement!(sentence,root_node)
        else
            # now, go down again, but pass the logic node as root -
            return recursive_long_or_logic_trailing_and_statement!(sentence,root_node)
        end

    elseif (next_token.token_type == :GENE_SYMBOL)

        # build a gene node -
        bio_node_1 = ast_node_factory(next_token)
        if (root_node.node_type == :OR || root_node.node_type == :AND)

            # add bio node to the root -
            push!(root_node.children_array,bio_node_1)

            # go down again -
            return recursive_long_or_logic_trailing_and_statement!(sentence,root_node)
        else
            # pass the gene node as root -
            return recursive_long_or_logic_trailing_and_statement!(sentence,bio_node_1)
        end

    elseif (next_token.token_type == :OR)

        if (root_node.node_type == :OR)
            return recursive_long_or_logic_trailing_and_statement!(sentence,root_node)
        else

            # build logic node -
            logic_node = ast_node_factory(next_token)

            # add root node as child of the logic node -
            push!(logic_node.children_array,root_node)

            # go down again, pass the logic node as root -
            return recursive_long_or_logic_trailing_and_statement!(sentence,logic_node)
        end
    elseif (next_token.token_type == :RPAREN)
        return recursive_long_or_logic_trailing_and_statement!(sentence,root_node)
    elseif (next_token.token_type == :STOP)
        return root_node
    end

    # default: return nothing
    return nothing
end

# astree for:
# ((2992.1 and 2998.1) or (8908.1 and 2997.1) or (2992.1 and 2997.1) or (8908.1 and 2998.1));
function recursive_build_muliple_nested_logical_clause_statement!(sentence,root_node)

    # pop the next token from the sentence -
    next_token = pop!(sentence)
    if (next_token.token_type == :LPAREN)

        if (root_node.node_type == :LPAREN)

            # create clause -
            biological_symbol_token_1 = pop!(sentence)
            logical_token = pop!(sentence)
            biological_symbol_token_2 = pop!(sentence)

            # create logic/bio node -
            logic_node = ast_node_factory(logical_token)
            bio_node_1 = ast_node_factory(biological_symbol_token_1)
            bio_node_2 = ast_node_factory(biological_symbol_token_2)

            # add bionodes to logical node (create logic tree)
            push!(logic_node.children_array,bio_node_1)
            push!(logic_node.children_array,bio_node_2)

            # now, go down again, but pass the logic node as root -
            return recursive_build_muliple_nested_logical_clause_statement!(sentence,logic_node)

        elseif (root_node.node_type == :OR || root_node.node_type == :AND)

            # create clause -
            biological_symbol_token_1 = pop!(sentence)
            logical_token = pop!(sentence)
            biological_symbol_token_2 = pop!(sentence)

            # create logic/bio node -
            logic_node = ast_node_factory(logical_token)
            bio_node_1 = ast_node_factory(biological_symbol_token_1)
            bio_node_2 = ast_node_factory(biological_symbol_token_2)

            # add bionodes to logical node (create logic tree)
            push!(logic_node.children_array,bio_node_1)
            push!(logic_node.children_array,bio_node_2)

            # then add logic tree to current root node -
            push!(root_node.children_array,logic_node)

            # now, go down again, but pass the root node as root -
            return recursive_build_muliple_nested_logical_clause_statement!(sentence,root_node)
        else
            # create a ( node
            lparen_node = ast_node_factory(next_token)
            return recursive_build_muliple_nested_logical_clause_statement!(sentence,lparen_node)
        end
    elseif (next_token.token_type == :OR || next_token.token_type == :AND)

        if (root_node.node_type == :AND || root_node.node_type == :OR)

            # ok, so the first time thru, set the is_acting_root flag to true

            # create logic node -
            logic_node = ast_node_factory(next_token)

            # add the root_node as a child of logic -
            push!(logic_node.children_array,root_node)

            # then we go down again, pass the logic node as root -
            return recursive_build_muliple_nested_logical_clause_statement!(sentence,logic_node)
        end
    elseif (next_token.token_type == :GENE_SYMBOL)

        if (root_node.node_type == :OR || root_node.node_type == :AND)

            # make bio symbol node -
            ast_node = ast_node_factory(next_token)

            # add as a child to the logic node (root)
            push!(root_node.children_array,ast_node)

            # go down once more into the breach ...
            return recursive_build_muliple_nested_logical_clause_statement!(sentence,root_node)
        end
    elseif (next_token.token_type == :RPAREN)
        return recursive_build_muliple_nested_logical_clause_statement!(sentence,root_node)
    elseif (next_token.token_type == :STOP)
        return root_node
    end

    # default: return nothing
    return nothing

end

# astree for:
# ((2108.1 and/or 2109.2) and/or (2108.1 and/or 2109.1));
function recursive_build_balanced_single_leading_trailing_statement!(sentence,root_node)

    # pop the next token from the sentence -
    next_token = pop!(sentence)
    if (next_token.token_type == :LPAREN)

        if (root_node.node_type == :LPAREN)

            # create clause -
            biological_symbol_token_1 = pop!(sentence)
            logical_token = pop!(sentence)
            biological_symbol_token_2 = pop!(sentence)

            # create logic/bio node -
            logic_node = ast_node_factory(logical_token)
            bio_node_1 = ast_node_factory(biological_symbol_token_1)
            bio_node_2 = ast_node_factory(biological_symbol_token_2)

            # add bionodes to logical node (create logic tree)
            push!(logic_node.children_array,bio_node_1)
            push!(logic_node.children_array,bio_node_2)

            # now, go down again, but pass the logic node as root -
            return recursive_build_balanced_single_leading_trailing_statement!(sentence,logic_node)

        elseif (root_node.node_type == :OR || root_node.node_type == :AND)

            # create clause -
            biological_symbol_token_1 = pop!(sentence)
            logical_token = pop!(sentence)
            biological_symbol_token_2 = pop!(sentence)

            # create logic/bio node -
            logic_node = ast_node_factory(logical_token)
            bio_node_1 = ast_node_factory(biological_symbol_token_1)
            bio_node_2 = ast_node_factory(biological_symbol_token_2)

            # add bionodes to logical node (create logic tree)
            push!(logic_node.children_array,bio_node_1)
            push!(logic_node.children_array,bio_node_2)

            # then add logic tree to current root node -
            push!(root_node.children_array,logic_node)

            # now, go down again, but pass the root node as root -
            return recursive_build_balanced_single_leading_trailing_statement!(sentence,root_node)
        else
            # create a ( node
            lparen_node = ast_node_factory(next_token)
            return recursive_build_balanced_single_leading_trailing_statement!(sentence,lparen_node)
        end
    elseif (next_token.token_type == :OR || next_token.token_type == :AND)

        if (root_node.node_type == :AND || root_node.node_type == :OR)

            # create logic node -
            logic_node = ast_node_factory(next_token)

            # add the root_node as a child of logic -
            push!(logic_node.children_array,root_node)

            # then we go down again, pass the logic node as root -
            return recursive_build_balanced_single_leading_trailing_statement!(sentence,logic_node)
        end
    elseif (next_token.token_type == :GENE_SYMBOL)

        if (root_node.node_type == :OR || root_node.node_type == :AND)

            # make bio symbol node -
            ast_node = ast_node_factory(next_token)

            # add as a child to the logic node (root)
            push!(root_node.children_array,ast_node)

            # go down once more into the breach ...
            return recursive_build_balanced_single_leading_trailing_statement!(sentence,root_node)
        end
    elseif (next_token.token_type == :RPAREN)
        return recursive_build_balanced_single_leading_trailing_statement!(sentence,root_node)
    elseif (next_token.token_type == :STOP)
        return root_node
    end

    # default: return nothing
    return nothing
end

# tree astree for:
# ((3030.1 and/or 3032.1) and/or 38.1);
function recursive_build_single_logical_leading_statement!(sentence,root_node)

    # pop the next token from the sentence -
    next_token = pop!(sentence)
    if (next_token.token_type == :LPAREN)
        if (root_node.node_type == :LPAREN)

            # create clause -
            biological_symbol_token_1 = pop!(sentence)
            logical_token = pop!(sentence)
            biological_symbol_token_2 = pop!(sentence)

            # create logic/bio node -
            logic_node = ast_node_factory(logical_token)
            bio_node_1 = ast_node_factory(biological_symbol_token_1)
            bio_node_2 = ast_node_factory(biological_symbol_token_2)

            # add bionodes to logical node (create logic tree)
            push!(logic_node.children_array,bio_node_1)
            push!(logic_node.children_array,bio_node_2)

            # now, go down again, but pass the logic node as root -
            return recursive_build_single_logical_leading_statement!(sentence,logic_node)
        else

            # create a ( node
            lparen_node = ast_node_factory(next_token)
            return recursive_build_single_logical_leading_statement!(sentence,lparen_node)
        end
    elseif (next_token.token_type == :RPAREN)
        return recursive_build_single_logical_leading_statement!(sentence,root_node)
    elseif (next_token.token_type == :OR || next_token.token_type == :AND)

        if (root_node.node_type == :AND || root_node.node_type == :OR)

            # create logic node -
            logic_node = ast_node_factory(next_token)

            # add the root_node as a child of logic -
            push!(logic_node.children_array,root_node)

            # then we go down again, pass the logic node as root -
            return recursive_build_single_logical_leading_statement!(sentence,logic_node)
        end
    elseif (next_token.token_type == :GENE_SYMBOL)

        if (root_node.node_type == :OR || root_node.node_type == :AND)

            # make bio symbol node -
            ast_node = ast_node_factory(next_token)

            # add as a child to the logic node (root)
            push!(root_node.children_array,ast_node)

            # go down once more into the breach ...
            return recursive_build_single_logical_leading_statement!(sentence,root_node)
        end
    elseif (next_token.token_type == :RPAREN)
        return recursive_build_single_logical_leading_statement!(sentence,root_node)
    elseif (next_token.token_type == :STOP)
        return root_node
    end

    # default: return nothing
    return nothing
end

# build astree for:
# (1892.1 or/and (3030.1 or/and 3032.1));
function recursive_build_single_logical_trailing_statement!(sentence,root_node)

    # pop the next token from the sentence -
    next_token = pop!(sentence)
    if (next_token.token_type == :LPAREN)

        if (root_node.node_type == :OR || root_node.node_type == :AND)

            # ok, so we are in the middle of the sentence, and it looks like
            # we are starting sometype of dependent clause -

            # the next token should be a biological symbol -
            biological_symbol_token_1 = pop!(sentence)
            logical_token = pop!(sentence)
            biological_symbol_token_2 = pop!(sentence)

            # create logic node -
            logic_node = ast_node_factory(logical_token)
            bio_node_1 = ast_node_factory(biological_symbol_token_1)
            bio_node_2 = ast_node_factory(biological_symbol_token_2)

            # add bionodes to logical node (create logic tree)
            push!(logic_node.children_array,bio_node_1)
            push!(logic_node.children_array,bio_node_2)

            # lastly, set "logic tree" as child of incoming OR/AND
            push!(root_node.children_array,logic_node)

            # now, go down again, but pass the clause node as root -
            return recursive_build_single_logical_trailing_statement!(sentence,root_node)
        else

            # normal (  => go down again ...
            return recursive_build_single_logical_trailing_statement!(sentence,root_node)
        end

    elseif (next_token.token_type == :GENE_SYMBOL)

        # build tree node -
        ast_node = ASTNode()
        ast_node.lexeme = next_token.lexeme
        ast_node.node_type = :GENE_SYMBOL
        ast_node.children_array = ASTNode[]

        if (root_node.node_type == :OR || root_node.node_type == :AND)

            # ok, so we are in sometype of relationship clause ... add me to logical node as a child
            push!(root_node.children_array,ast_node)


            # go down again w/root as root -
            return recursive_build_single_logical_trailing_statement!(sentence,root_node)
        elseif (root_node.node_type == :CLAUSE_STATEMENT)

            # add myself to the clause, and go down again -
            push!(root_node.children_array,ast_node)

            # go down - pass *me* as root -
            return recursive_build_single_logical_trailing_statement!(sentence,root_node)
        else

            # not sure why I need this ...
            # push!(root_node.children_array,ast_node)

            # go down - pass *me* as root -
            return recursive_build_single_logical_trailing_statement!(sentence,ast_node)
        end
    elseif (next_token.token_type == :OR || next_token.token_type == :AND)

        # ok, build a logical node, *add* the node passed in as a child of me
        # build tree node -
        ast_node = ASTNode()
        ast_node.lexeme = next_token.lexeme
        ast_node.node_type = next_token.token_type
        ast_node.children_array = ASTNode[]

        if (root_node.node_type == :CLAUSE_STATEMENT)

            # add me as a child of the clause -
            push!(root_node.children_array,ast_node)

            # go down again - clause as root -
            return recursive_build_single_logical_trailing_statement!(sentence,root_node)

        elseif (root_node.node_type == :GENE_SYMBOL)

            # this makes the symbol a child of the logical node -
            push!(ast_node.children_array,root_node)

            # keep going ...
            return recursive_build_single_logical_trailing_statement!(sentence,ast_node)
        end
    elseif (next_token.token_type == :RPAREN)
        # keep going ...
        return recursive_build_single_logical_trailing_statement!(sentence,root_node)
    elseif (next_token.token_type == :STOP)
        return root_node
    end

    # default - return nothing ...
    return nothing
end


function recursive_build_direct_relationship!(sentence,root_node)

    # pop the next token from the sentence -
    next_token = pop!(sentence)
    if (next_token.token_type == :GENE_SYMBOL)

        # build tree node -
        ast_node = ASTNode()
        ast_node.lexeme = next_token.lexeme
        ast_node.node_type = :GENE_SYMBOL
        ast_node.children_array = ASTNode[]

        # add me to the root -
        # push!(root_node.children_array,ast_node)

        # go down again -
        return recursive_build_direct_relationship!(sentence,ast_node)
    elseif (next_token.token_type == :STOP)
        return root_node
    end

    # default -
    return nothing
end

# astree for:
# (51166.1 or 51166.2 or X or Y or ...);
function recursive_build_two_component_logical_relationship!(sentence,root_node)

    # pop the next token from the sentence -
    next_token = pop!(sentence)
    if (next_token.token_type == :LPAREN)

        # go down again -
        return recursive_build_two_component_logical_relationship!(sentence,root_node)
    elseif (next_token.token_type == :GENE_SYMBOL)

        # ok, we have a gene symbol - so lets build a gene node -
        ast_node = ast_node_factory(next_token)
        if (root_node.node_type == :OR || root_node.node_type == :AND)

            # add me to the OR/AND, and go down again -
            push!(root_node.children_array,ast_node)
            return recursive_build_two_component_logical_relationship!(sentence,root_node)
        else
            return recursive_build_two_component_logical_relationship!(sentence,ast_node)
        end

    elseif (next_token.token_type == :AND || next_token.token_type == :OR)

        # if I get here, then I have an AND or OR, and my root node is the AST biological symbol -
        ast_node = ast_node_factory(next_token)
        if (root_node.node_type == :GENE_SYMBOL)

            # add the gene symbol to me -
            push!(ast_node.children_array,root_node)

            # go down again -
            return recursive_build_two_component_logical_relationship!(sentence,ast_node)
        elseif (root_node.node_type == :OR || root_node.node_type == :AND)

            # do nothing - go down again -
            return recursive_build_two_component_logical_relationship!(sentence,root_node)
        end


    elseif (next_token.token_type == :RPAREN)

        return recursive_build_two_component_logical_relationship!(sentence,root_node)

    elseif (next_token.token_type == :STOP)
        return root_node
    end

    return nothing
end
