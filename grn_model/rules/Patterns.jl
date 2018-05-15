


# check for:
# (X1 or X2 or X3 ... or XN)
function scan_all_or_logic(sentence)

    # make a copy -
    next_token = pop!(sentence)
    if (next_token.token_type == :LPAREN)
        return scan_all_or_logic(sentence)
    elseif (next_token.token_type == :GENE_SYMBOL)
        return scan_all_or_logic(sentence)
    elseif (next_token.token_type == :OR)
        return scan_all_or_logic(sentence)
    elseif (next_token.token_type == :RPAREN)
        return scan_all_or_logic(sentence)
    elseif (next_token.token_type == :AND)
        return false
    elseif (next_token.token_type == :STOP)
        return true
    end

    return false
end

# check for:
# (X1 and X2 and X3 ... and XN)
function scan_all_and_logic(sentence)

    # grab the first token ...
    next_token = pop!(sentence)
    if (next_token.token_type == :LPAREN)
        return scan_all_and_logic(sentence)
    elseif (next_token.token_type == :GENE_SYMBOL)
        return scan_all_and_logic(sentence)
    elseif (next_token.token_type == :OR)
        return false
    elseif (next_token.token_type == :RPAREN)
        return scan_all_and_logic(sentence)
    elseif (next_token.token_type == :AND)
        return scan_all_and_logic(sentence)
    elseif (next_token.token_type == :STOP)
        return true
    end

    return false
end

# check for:
# (549.1 or 1892.1 or (3030.1 and 3032.1)); 11
# (3939.1 or 3945.1 or 3948.1 or 3948.2 or 92483.1 or 160287.1 or 55293.1 or (3939.1 and 3945.1)); 21
# (3939.1 or 3945.1 or 3948.1 or 3948.2 or 92483.1 or 160287.1 or 55293.1 or X or (3939.1 and 3945.1)); 23
# (3939.1 or 3945.1 or 3948.1 or 3948.2 or 92483.1 or 160287.1 or 55293.1 or X or Z or (3939.1 and 3945.1)); 25
function scan_for_long_or_logic_trailing_and_clause(sentence,level)

    @show level

    next_token = pop!(sentence)
    if (next_token.token_type == :LPAREN && (level == 0 || in(level,collect(1:2:100)) == true))
        level = level + 1
        return scan_for_long_or_logic_trailing_and_clause(sentence,level)
    elseif (next_token.token_type == :GENE_SYMBOL)
        level = level + 1
        return scan_for_long_or_logic_trailing_and_clause(sentence,level)
    elseif (next_token.token_type == :OR)
        level = level + 1
        return scan_for_long_or_logic_trailing_and_clause(sentence,level)
    elseif (next_token.token_type == :AND && (in(level,collect(5:2:100)) == true))
        level = level + 1
        return scan_for_long_or_logic_trailing_and_clause(sentence,level)
    elseif (next_token.token_type == :RPAREN)
        level = level + 1
        return scan_for_long_or_logic_trailing_and_clause(sentence,level)
    elseif (next_token.token_type == :STOP && (in(level,collect(11:2:100)) == true))
        return true
    end

    # default -
    return false
end


# check for:
# ((2992.1 and 2998.1) or (8908.1 and 2997.1) or (2992.1 and 2997.1) or (8908.1 and 2998.1));
function scan_muliple_nested_logical_clause_statement(sentence,level)

    next_token = pop!(sentence)
    if (next_token.token_type == :LPAREN && (level == 0 || level == 1 || level == 7 || level == 13 || level == 19))
        level = level + 1
        return scan_muliple_nested_logical_clause_statement(sentence,level)
    elseif ((next_token.token_type == :AND || next_token.token_type == :OR) &&
        (level == 3 || level == 6 || level == 9 || level == 12 || level == 15 || level == 18 || level == 21))
        level = level + 1
        return scan_muliple_nested_logical_clause_statement(sentence,level)
    elseif (next_token.token_type == :GENE_SYMBOL &&
        (level == 2 || level == 4 || level == 8 || level == 10 || level == 14 || level == 16 || level == 20 || level == 22))
        level = level + 1
        return scan_muliple_nested_logical_clause_statement(sentence,level)
    elseif (next_token.token_type == :RPAREN)
        level = level + 1
        return scan_muliple_nested_logical_clause_statement(sentence,level)
    elseif (next_token.token_type == :STOP && level == 25)
        return true
    end

    # default -
    return false
end

# check for:
# ((2108.1 and 2109.2) or (2108.1 and 2109.1));
function scan_balanced_single_leading_trailing_clause(sentence,level)

    next_token = pop!(sentence)
    if (next_token.token_type == :LPAREN && (level == 0 || level == 1) || level == 7)
        level = level + 1
        return scan_balanced_single_leading_trailing_clause(sentence,level)
    elseif ((next_token.token_type == :AND || next_token.token_type == :OR) && (level == 3 || level == 6 || level == 9))
        level = level + 1
        return scan_balanced_single_leading_trailing_clause(sentence,level)
    elseif (next_token.token_type == :GENE_SYMBOL && (level == 2 || level == 4 || level == 8 || level == 10))
        level = level + 1
        return scan_balanced_single_leading_trailing_clause(sentence,level)
    elseif (next_token.token_type == :RPAREN)
        level = level + 1
        return scan_balanced_single_leading_trailing_clause(sentence,level)
    elseif (next_token.token_type == :STOP && level == 13)
        return true
    end

    # default -
    return false
end

# check for:
# (1892.1 or/and (3030.1 or/and 3032.1));
function scan_single_logical_trailing_clause(sentence,level)

    next_token = pop!(sentence)
    if (next_token.token_type == :LPAREN && (level == 0 || level == 3))
        level = level + 1
        return scan_single_logical_trailing_clause(sentence,level)
    elseif ((next_token.token_type == :AND || next_token.token_type == :OR) && (level == 2 || level == 5))
        level = level + 1
        return scan_single_logical_trailing_clause(sentence,level)
    elseif (next_token.token_type == :GENE_SYMBOL && (level == 1 || level == 4 || level == 6))
        level = level + 1
        return scan_single_logical_trailing_clause(sentence,level)
    elseif (next_token.token_type == :RPAREN)
        level = level + 1
        return scan_single_logical_trailing_clause(sentence,level)
    elseif (next_token.token_type == :STOP && level == 9)
        return true
    end

    # default -
    return false
end

# check for:
# Pass: ((3030.1 and/or 3032.1) and/or 38.1);
# Fail: (1892.1 or/and (3030.1 or/and 3032.1));
function scan_single_logical_leading_clause(sentence,level)

    next_token = pop!(sentence)
    if (next_token.token_type == :LPAREN && (level == 0 || level == 1))
        level = level + 1
        return scan_single_logical_leading_clause(sentence,level)
    elseif (next_token.token_type == :GENE_SYMBOL && (level == 2 || level == 4 || level == 7))
        level = level + 1
        return scan_single_logical_leading_clause(sentence,level)
    elseif ((next_token.token_type == :OR || next_token.token_type == :AND) && (level == 3 || level == 6))
        level = level + 1
        return scan_single_logical_leading_clause(sentence,level)
    elseif (next_token.token_type == :RPAREN && (level == 5 || level == 8))
        level = level + 1
        return scan_single_logical_leading_clause(sentence,level)
    elseif (next_token.token_type == :STOP && level == 9)
        return true
    end

    # default -
    return false
end
