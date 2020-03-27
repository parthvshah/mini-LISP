#include <string.h>
#include <stdlib.h>
#include "ASTTree.hh"


ASTNode* makeLeafNode_id(char *n)
{
    ASTNode *new_node = new ASTNode;
    new_node->number_of_children = 0;
    new_node->type = 2;
    strcpy(new_node->id, n);
    new_node->child[2] = NULL;
    new_node->child[1] = NULL;
    new_node->child[0] = NULL;
    return new_node;
}
ASTNode* makeLeafNode_num(int n)
{
    ASTNode *new_node = new ASTNode;
    new_node->number_of_children = 0;
    new_node->type = 3;
    new_node->num_value = n;
    new_node->child[2] = NULL;
    new_node->child[1] = NULL;
    new_node->child[0] = NULL;
    return new_node;
}
ASTNode* makeLeafNode_bool(bool n)
{
    ASTNode *new_node = new ASTNode;
    new_node->number_of_children = 0;
    new_node->type = 4;
    new_node->bool_value = n;
    new_node->child[2] = NULL;
    new_node->child[1] = NULL;
    new_node->child[0] = NULL;
    return new_node;
}
ASTNode* makeLeafNode_str(char *n)
{
    ASTNode *new_node = new ASTNode;
    new_node->number_of_children = 0;
    new_node->type = 5;
    strcpy(new_node->str_value, n);
    new_node->child[2] = NULL;
    new_node->child[1] = NULL;
    new_node->child[0] = NULL;
    return new_node;
}


ASTNode* makeNode1(char *value, ASTNode *c1)
{
    ASTNode *new_node = new ASTNode;
    new_node->number_of_children = 1;
    new_node->type = 1;
    strcpy(new_node->ope, value);
    new_node->child[2] = NULL;
    new_node->child[1] = NULL;
    new_node->child[0] = NULL;
    new_node->child[0] = c1;
    return new_node;
}
ASTNode* makeNode2(char *value, ASTNode *c1, ASTNode *c2)
{
    ASTNode *new_node = new ASTNode;
    new_node->number_of_children = 2;
    new_node->type = 1;
    strcpy(new_node->ope, value);
    new_node->child[2] = NULL;
    new_node->child[1] = NULL;
    new_node->child[0] = NULL;
    new_node->child[0] = c1;
    new_node->child[1] = c2;
    return new_node;
}
ASTNode* makeNode3(char *value, ASTNode *c1, ASTNode *c2, ASTNode *c3)
{
    ASTNode *new_node = new ASTNode;
    new_node->number_of_children = 3;
    new_node->type = 1;
    strcpy(new_node->ope, value);
    new_node->child[2] = NULL;
    new_node->child[1] = NULL;
    new_node->child[0] = NULL;
    new_node->child[0] = c1;
    new_node->child[1] = c2;
    new_node->child[2] = c3;
    return new_node;
}

