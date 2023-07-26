import graphviz

def create_branch_diagram():
    # Create a Digraph object from graphviz
    dot = graphviz.Digraph()

    # Add branches and commits
    branches = {
        "master": [(0, "Initial commit")],
        "feature1": [(0, "Initial commit"), (1, "Add feature 1")],
        "feature2": [(0, "Initial commit"), (2, "Add feature 2")]
    }

    # Add branch names as nodes
    for branch in branches:
        dot.node(branch)

    # Add commits as nodes and edges
    for branch, commits in branches.items():
        for index, commit_msg in commits:
            commit_node = f"{branch}-{index}"
            dot.node(commit_node, label=commit_msg)
            dot.edge(branch, commit_node)

            if index > 0:
                prev_commit_node = f"{branch}-{index-1}"
                dot.edge(prev_commit_node, commit_node)

    # Render the graph
    dot.render("branch_diagram", format="png", cleanup=True)

if __name__ == "__main__":
    create_branch_diagram()

