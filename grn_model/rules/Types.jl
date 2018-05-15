# declare types -
abstract type AbstractToken end

mutable struct Token <: AbstractToken
    lexeme::String
    token_type::Symbol
end

immutable Sentence
  token_array::Array{Token,1}
end

mutable struct ASTNode

    lexeme::String
    node_type::Symbol
    children_array::Array{ASTNode,1}
    parent::ASTNode

    function ASTNode()
      this = new()
    end

end

mutable struct ASTTree

    root_node::ASTNode

    function ASTTree()
      this = new()
    end
end

mutable struct JuliaNode

    node_text::String

end
