typedef struct nodee{
    int number_of_children;
    struct nodee *child[3];
    int type;
    /*
        0 - NULL value
        1 - operator - for/while/if/+/-....
        2 - id
        3 - number value
        4 - bool value
        5 - string value
    */
    char ope[16];
    char id[100];
    int num_value;
    char bool_value;
    char *str_value;
}Node;
Node* makeLeafNode(int type, char *n);
Node* makeNode(int number_of_children,int type, char *value, Node *c1 = NULL, Node *c2 = NULL, Node *c3 = NULL);