import subprocess
from graph_tools.all import *

def get_branches():
    # Run the "git branch --all" command to get branch information
    output = subprocess.check_output(["git", "branch", "--all"]).decode("utf-8")

    branches = []

    # Process the output to extract branch names
    for line in output.splitlines():
        branch = line.strip()
        if branch.startswith("*"):
            branch = branch[1:].strip()  # Remove the asterisk from the current branch
        branches.append(branch)

    return branches

def create_branch_diagram(branch_name):
    # Create a graph
    g = Graph()

    # Define the properties of the graph elements
    vprops = g.new_vertex_property("string")
    eprops = g.new_edge_property("string")

    # Run the "git log --oneline" command to get commit information
    output = subprocess.check_output(["git", "log", "--oneline"]).decode("utf-8")

    commits = []

    # Process the output to extract commit information
    for line in output.splitlines():
        commit_hash, commit_msg = line.split(" ", 1)
        commits.append((commit_hash, commit_msg.strip()))

    vertices = {}
    edges = []

    for index, (commit_hash, commit_msg) in enumerate(commits):
        v = g.add_vertex()
        vprops[v] = f"{index}\n{commit_hash}\n{commit_msg}"
        vertices[commit_hash] = v

        if index > 0:
            prev_commit_hash, _ = commits[index - 1]
            prev_v = vertices[prev_commit_hash]
            e = g.add_edge(prev_v, v)
            eprops[e] = "parent"

    # Filter the graph based on the specified branch
    if branch_name != "all":
        try:
            branch_hash = subprocess.check_output(
                ["git", "rev-parse", branch_name]
            ).decode("utf-8").strip()
            branch_v = vertices[branch_hash]

            # Create a subgraph containing only the specified branch
            g.set_vertex_filter(g.new_vertex_property("bool", vals=[branch_v]))
        except subprocess.CalledProcessError:
            print(f"Branch '{branch_name}' not found.")
            return

    # Layout the graph
    pos = sfdp_layout(g)

    # Plot the graph
    graph_draw(
        g, pos=pos, vertex_text=vprops, edge_text=eprops, vertex_font_size=10,
        edge_font_size=10, output="branch_diagram.png"
    )

if __name__ == "__main__":
    branches = get_branches()

    print("Available branches:")
    for branch in branches:
        print(branch)

    branch_name = input("Enter the branch name to visualize (or 'all' for all branches): ")

    create_branch_diagram(branch_name)

