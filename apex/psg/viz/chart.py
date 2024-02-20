import graphviz

def generate_permission_set_graph(permission_set_groups):
    dot = graphviz.Digraph(format='png')
    
    # Add nodes for Permission Set Groups
    for group_name, permission_sets in permission_set_groups.items():
        dot.node(group_name, group_name, shape='box')
        
        # Add nodes for Permission Sets within each group
        for permission_set_name, permissions in permission_sets.items():
            dot.node(permission_set_name, permission_set_name, shape='ellipse')
            
            # Add nodes for Permissions within each Permission Set
            for permission in permissions:
                dot.node(permission, permission, shape='ellipse', style='filled', fillcolor='lightblue')
                
                # Connect Permission Set to Permissions
                dot.edge(permission_set_name, permission)
                
        # Connect Permission Set Group to Permission Sets
        dot.edge(group_name, permission_set_name)
    
    # Add nodes and edges for user assignments
    users = {
        'User1': {'PermissionSetGroup1', 'PermissionSet1'},
        'User2': {'PermissionSetGroup1', 'PermissionSet2'},
        'User3': {'PermissionSetGroup2', 'PermissionSet1'},
        'User4': {'PermissionSetGroup2', 'PermissionSet2'},
    }
    
    for user, assigned_sets in users.items():
        dot.node(user, user, shape='ellipse', style='filled', fillcolor='lightgreen')
        for assigned_set in assigned_sets:
            dot.edge(assigned_set, user)
    
    return dot

# Define your permission set groups, permission sets, and permissions
permission_set_groups = {
    'PermissionSetGroup1': {
        'PermissionSet1': ['Permission1', 'Permission2'],
        'PermissionSet2': ['Permission3', 'Permission4']
    },
    'PermissionSetGroup2': {
        'PermissionSet1': ['Permission1', 'Permission2'],
        'PermissionSet2': ['Permission3', 'Permission4']
    }
}

# Generate and save the graph
graph = generate_permission_set_graph(permission_set_groups)
graph.render('permission_set_graph', format='png', cleanup=True)
