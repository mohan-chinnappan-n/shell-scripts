import pandas as pd
import matplotlib.pyplot as plot

# A python dictionary
data = {"City":["London", "Paris", "Rome"],

        "Visits":[20.42,17.95,9.7]

        };

# Dictionary loaded into a DataFrame       
dataFrame = pd.DataFrame(data=data);

# Draw a vertical bar chart
dataFrame.plot.bar(x="City", y="Visits", rot=70, title="Number of tourist visits - Year 2018");

plot.show(block=True);
