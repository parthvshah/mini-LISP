#include "ASTTree.hh"

std::stack<ASTNode*> global_param_stk;

ASTNode* constructAST(ASTNode *exp1, ASTNode *exp2){
    ASTNode *new_node = (ASTNode*)malloc(sizeof(ASTNode));
    new_node->type = type_stk.top();
    new_node->left = exp1;
    new_node->right = exp2;
    type_stk.pop();
    return new_node;
}

ASTNode* constructAST(ASTNode *exp1, ASTNode *exp2, ASTNode *exp3){
    ASTNode *new_node = (ASTNode*)malloc(sizeof(ASTNode));
    new_node->type = type_stk.top();
    new_node->left = exp1;
    ASTNode *new_node_right = (ASTNode*)malloc(sizeof(ASTNode));
    new_node_right->type = type_stk.top();
    new_node_right->left = exp2;
    new_node_right->right = exp3;
    new_node->right = new_node_right;
    type_stk.pop();
    return new_node;
}

int calNumber(ASTNode *current, std::map<std::string, ASTNode*> &local_id_map){
    if(!current) return 1;
    int ret;
    ASTVal *tmp;
    switch(current->type){
        case AST_PLUS:
            if(current->right)
                ret = calNumber(current->left, local_id_map) + calNumber(current->right, local_id_map);
            else
                ret = calNumber(current->left, local_id_map);
            break;
        case AST_MINUS:
            ret = calNumber(current->left, local_id_map) - calNumber(current->right, local_id_map);
            break;
        case AST_MULTIPLY:
            if(current->right)
                ret = calNumber(current->left, local_id_map) * calNumber(current->right, local_id_map);
            else
                ret = calNumber(current->left, local_id_map);
            break;
        case AST_DIVIDE:
            ret = calNumber(current->left, local_id_map) / calNumber(current->right, local_id_map);
            break;
        case AST_MODULES:
            ret = calNumber(current->left, local_id_map) % calNumber(current->right, local_id_map);
            break;
        case AST_NUMBER:
            ret = ((ASTNumber*)current)->number;
            break;
        case AST_SMALLER:
        case AST_GREATER:
        case AST_EQUAL:
        case AST_AND:
        case AST_OR:
        case AST_NOT:
        case AST_BOOLVAL:
            std::cout << "Type Error: Expect 'number' but got 'boolean'\n";
            exit(0);
            break;
        case AST_FUN:
        case AST_FUN_DEF_CALL:
        case AST_FUN_CALL:
        case AST_ID:
            tmp = ASTVisit(current, local_id_map);
            if(tmp->type != AST_NUMBER){
                std::cout << "Type Error: Expect 'number' but got 'boolean'\n";
                exit(0);
            }
            ret = tmp->number;
            break;
        default:
            ret = ASTVisit(current, local_id_map)->number;
    }
    return ret;
}

bool ASTEqual(ASTNode *current, std::map<std::string, ASTNode*> &local_id_map){
    if(current->right){
        if(calNumber(current->left, local_id_map) == calNumber(current->right->left, local_id_map))
            return ASTEqual(current->right, local_id_map);
        else 
            return false;
    }
    else 
        return true;
}

bool calLogic(ASTNode *current, std::map<std::string, ASTNode*> &local_id_map){
    if(!current) return true;
    bool ret;
    ASTVal *tmp;
    switch(current->type){
        case AST_AND:
            ret = calLogic(current->left, local_id_map) && calLogic(current->right, local_id_map);
            break;
        case AST_OR:
            if(current->right)
                ret = calLogic(current->left, local_id_map) || calLogic(current->right, local_id_map);
            else 
                ret = calLogic(current->left, local_id_map);
            break;
        case AST_NOT:
            ret = !calLogic(current->left, local_id_map);
            break;
        case AST_GREATER:
            ret = ( calNumber(current->left, local_id_map) > calNumber(current->right, local_id_map) );
            break;
        case AST_SMALLER:
            ret = ( calNumber(current->left, local_id_map) < calNumber(current->right, local_id_map) );
            break;
        case AST_EQUAL:
            ret = ASTEqual(current, local_id_map);
            break;
        case AST_BOOLVAL:
            ret = ((ASTBoolVal*)current)->bool_val;
            break;
        case AST_PLUS:
        case AST_MINUS:
        case AST_MULTIPLY:
        case AST_DIVIDE:
        case AST_MODULES:
        case AST_NUMBER:
            std::cout << "Type Error: Expect 'boolean' but got 'number'\n";
            exit(0);
            break;
        case AST_FUN:
        case AST_FUN_DEF_CALL:
        case AST_FUN_CALL:
        case AST_ID:
            tmp = ASTVisit(current, local_id_map);
            if(tmp->type != AST_BOOLVAL){
                std::cout << "Type Error: Expect 'number' but got 'boolean'\n";
                exit(0);
            }
            ret = tmp->bool_val;
            break;
        default:
            ret = ASTVisit(current, local_id_map)->bool_val;
    }
    return ret;
}

void defineID(ASTNode *current, std::map<std::string, ASTNode*> &local_id_map){
    std::string defID = ((ASTId*)current->left)->id;
    if(local_id_map[defID]){
        std::cout << "Redefined id: " << defID << "\n";
        exit(0);
    }
    else 
        local_id_map[defID] = current->right;
}

ASTVal* ASTFun(ASTNode *fun_exp, ASTNode *param, std::map<std::string, ASTNode*> &local_id_map){
    ASTNode *fun_id = fun_exp->left;
    ASTNode *fun_body = fun_exp->right;
    ASTNode *param_tmp = param;
    std::map<std::string, ASTNode*> new_id_map = local_id_map;
    std::stack<ASTNode*> param_stk;
    std::stack<std::string> id_stk;
    if(!param){
        if(global_param_stk.size()){
            while(fun_id){
                id_stk.push(((ASTId*)fun_id->left)->id);
                fun_id = fun_id->right;
            }
            while(id_stk.size()){
                new_id_map[id_stk.top()] = global_param_stk.top();
                id_stk.pop();
                global_param_stk.pop();
            }
            return ASTVisit(fun_body, new_id_map);
        }
        return ASTVisit(fun_body, new_id_map);
    }
    
    while(param_tmp){
        if(param_tmp->left->type == AST_FUN){
            param_stk.push(param_tmp->left);
        } else {
            ASTNode *tmp = (ASTNode *)ASTVisit(param_tmp->left, new_id_map);
            param_stk.push(tmp);
        }
        param_tmp = param_tmp->right;
    }
    while(fun_id){
        id_stk.push(((ASTId*)fun_id->left)->id);
        fun_id = fun_id->right;
    }

    if(param_stk.size() == id_stk.size()) {
        while(param_stk.size()){
            new_id_map[id_stk.top()] = param_stk.top();
            id_stk.pop();
            param_stk.pop();
        }
    }
    else {
        std::cout << "parameter numbers not match: need " << id_stk.size() << " but " << param_stk.size()  << "\n";
        exit(0);
    }
    return ASTVisit(fun_body, new_id_map);
}

ASTVal* ASTFunBody(ASTNode *current, std::map<std::string, ASTNode*> &local_id_map){
    while(current->right){
        ASTVisit(current->left, local_id_map);
        current = current->right;
    }
    return ASTVisit(current->left, local_id_map);
}

ASTVal* ASTFunClosure(ASTNode *current, std::map<std::string, ASTNode*> &local_id_map){
    ASTNode *tmp = current;
    std::map<std::string, ASTNode*> new_id_map = local_id_map;
    while(local_id_map[((ASTId*)tmp->left)->id]->type != AST_FUN){
        ASTNode *param = tmp->right;
        while(param){
            if(param->left->type == AST_FUN){
                global_param_stk.push(param->left);
            } else {
                ASTNode *tmp = (ASTNode *)ASTVisit(param->left, new_id_map);
                global_param_stk.push(tmp);
            }
            param = param->right;
        }
        tmp = local_id_map[((ASTId*)tmp->left)->id];
    }
    return ASTFun(local_id_map[((ASTId*)tmp->left)->id], tmp->right, local_id_map);
}

ASTNode* ASTIfstmt(ASTNode *current, std::map<std::string, ASTNode*> &local_id_map){
    bool result = calLogic(((ASTIf*)current)->deter, local_id_map);
    if(result)
        return current->left;
    else 
        return current->right;
}

ASTVal* ASTVisit(ASTNode *current, std::map<std::string, ASTNode*> &local_id_map){
    if(!current) return NULL;
    ASTVal *ret = (ASTVal*)malloc(sizeof(ASTVal));
    switch(current->type){
        case AST_ROOT:
            ASTVisit(current->left, local_id_map);
            ASTVisit(current->right, local_id_map);
            break;
        case AST_PNUMBER:
            ret = ASTVisit(current->left, local_id_map);
            std::cout << ret->number << "\n";
            break;
        case AST_PBOOLVAL:
            ret = ASTVisit(current->left, local_id_map);
            std::cout << (ret->bool_val ? "#t" : "#f" ) << "\n";
            break;
        case AST_PLUS:
        case AST_MINUS:
        case AST_MULTIPLY:
        case AST_DIVIDE:
        case AST_MODULES:
        case AST_NUMBER:
            ret->type = AST_NUMBER;
            ret->number = calNumber(current, local_id_map);
            break;
        case AST_GREATER:
        case AST_SMALLER:
        case AST_EQUAL:
        case AST_AND:
        case AST_OR:
        case AST_NOT:
        case AST_BOOLVAL:
            ret->type = AST_BOOLVAL;
            ret->bool_val = calLogic(current, local_id_map);
            break;
        case AST_DEFINE:
            defineID(current, local_id_map);
            break;
        case AST_ID:
            if(!local_id_map[((ASTId*)current)->id]){
                std::cout << "Undefined id: " << ((ASTId*)current)->id << "\n";
                exit(0);
            }
            else
                ret = ASTVisit(local_id_map[((ASTId*)current)->id], local_id_map);
            break;
        case AST_FUN: 
            ret = ASTFun(current, NULL, local_id_map);
            break;
        case AST_FUN_DEF_CALL:
            ret = ASTFun(current->left, current->right, local_id_map);
            break;
        case AST_FUN_CALL:
            if(!local_id_map[((ASTId*)current->left)->id]){
                std::cout << "Undefined function name: " << ((ASTId*)current->left)->id << "\n";
                exit(0);     
            }
            else if(local_id_map[((ASTId*)current->left)->id]->type == AST_FUN)
                ret = ASTFun(local_id_map[((ASTId*)current->left)->id], current->right, local_id_map);
            else {
                ret = ASTFunClosure(current, local_id_map);
                if(global_param_stk.size()){
                    std::cout << "parameter numbers not match: " << global_param_stk.size() << " parameters not used\n";
                    exit(0);
                }
            }
            break;
        case AST_FUN_BODY:
            ret = ASTFunBody(current, local_id_map);
            break;
        case AST_IF:
            ret = ASTVisit(ASTIfstmt(current, local_id_map), local_id_map);
            break;
        default:
            std::cout << "unexpected error!\n";
            exit(0);
    }
    return ret;
}