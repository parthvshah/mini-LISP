#include <string.h>
#include <stdlib.h>
#include "ASTTree.hh"

Node* makeLeafNode(int type, char *n)
{
    Node *new_node = new Node;
    new_node->number_of_children = 0;
    new_node->type = type;
    switch(type)
    {
        case 2: strcpy(new_node->id, n);
                break;
        case 3: new_node->num_value = atoi(n);
                break;
        case 4: new_node->bool_value = atoi(n);
                break;
        case 5: strcpy(new_node->str_value, n);
                break;
    }
    new_node->child[2] = NULL;
    new_node->child[1] = NULL;
    new_node->child[0] = NULL;
    return new_node;
}

Node* makeNode(int number_of_children, char *value, Node *c1 = NULL, Node *c2 = NULL, Node *c3 = NULL)
{
    Node *new_node = new Node;
    new_node->number_of_children = number_of_children;
    new_node->type = 1;
    strcpy(new_node->ope, value);
    new_node->child[2] = NULL;
    new_node->child[1] = NULL;
    new_node->child[0] = NULL;
    switch(number_of_children)
    {
        case 3:new_node->child[2] = c3;
        case 2:new_node->child[1] = c2;
        case 1:new_node->child[0] = c1;
                break;
        default: break;
    }
    return new_node;
}

