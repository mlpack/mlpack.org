var cppCode = "";
cppCode = "#include <mlpack/core.hpp>\r\n";
cppCode +=
  "#include <mlpack/methods/neighbor_search/neighbor_search.hpp>\r\n\r\n";
cppCode += "using namespace mlpack;\r\n";
cppCode +=
  "using namespace mlpack::neighbor; // NeighborSearch and NearestNeighborSort\r\n";
cppCode += "using namespace mlpack::metric; // ManhattanDistance\r\n\r\n";
cppCode += "int main()\r\n";
cppCode += "{\r\n";
cppCode +=
  "  // Load the data from data.csv (hard-coded).  Use CLI for simple command-line\r\n";
cppCode += "  // parameter handling.\r\n";
cppCode += '  arma::mat data("0.339406815,0.843176636,0.472701471; \\\r\n';
cppCode += "                  0.212587646,0.351174901,0.81056695;  \\\r\n";
cppCode += "                  0.160147626,0.255047893,0.04072469;  \\\r\n";
cppCode += '                  0.564535197,0.943435462,0.597070812"); \r\n';
cppCode += "  data = data.t(); \r\n\r\n";
cppCode +=
  "  // Use templates to specify that we want a NeighborSearch object which uses\r\n";
cppCode += "  // the Manhattan distance.\r\n";
cppCode +=
  "  NeighborSearch<NearestNeighborSort, ManhattanDistance> nn(data);\r\n\r\n";
cppCode += "  // Create the object we will store the nearest neighbors in.\r\n";
cppCode += "  arma::Mat<size_t> neighbors;\r\n";
cppCode +=
  "  arma::mat distances; // We need to store the distance too.\r\n\r\n";
cppCode += "  // Compute the neighbors.\r\n";
cppCode += "  nn.Search(1, neighbors, distances);\r\n\r\n";
cppCode += "  // Write each neighbor and distance using Log.\r\n";
cppCode += "  for (size_t i = 0; i < neighbors.n_elem; ++i)\r\n";
cppCode += "  {\r\n";
cppCode +=
  '    std::cout << "Nearest neighbor of point " << i << " is point "\r\n';
cppCode +=
  '        << neighbors[i] << " and the distance is " << distances[i] << "." << std::endl;\r\n';
cppCode += "  }\r\n\r\n";
cppCode += "  return 0;\r\n";
cppCode += "}\r\n";

var pythonCode = "";
pythonCode = "import mlpack\r\n";
pythonCode += "import pandas as pd\r\n";
pythonCode += "import numpy as np\r\n\r\n";
pythonCode +=
  '# Load the dataset from an online URL.  Replace with "covertype.csv.gz" if you\r\n';
pythonCode += "# want to use on the full dataset.\r\n";
pythonCode +=
  'df = pd.read_csv("https://lab.mlpack.org/data/covertype-small.csv.gz")\r\n\r\n';
pythonCode += "# Split the labels.\r\n";
pythonCode += 'labels = df["label"]\r\n';
pythonCode += 'dataset = df.drop("label", 1)\r\n\r\n';
pythonCode +=
  "# Split the dataset using mlpack.  The output comes back as a dictionary,\r\n";
pythonCode += "# which we will unpack for clarity of code.\r\n";
pythonCode += "output = mlpack.preprocess_split(input=dataset,\r\n";
pythonCode += "                                 input_labels=labels,\r\n";
pythonCode += "                                 test_ratio=0.3)\r\n";
pythonCode += 'training_set = output["training"]\r\n';
pythonCode += 'training_labels = output["training_labels"]\r\n';
pythonCode += 'test_set = output["test"]\r\n';
pythonCode += 'test_labels = output["test_labels"]\r\n\r\n';
pythonCode += "# Train a random forest.\r\n";
pythonCode += "output = mlpack.random_forest(training=training_set,\r\n";
pythonCode += "                              labels=training_labels,\r\n";
pythonCode += "                              print_training_accuracy=True,\r\n";
pythonCode += "                              num_trees=10,\r\n";
pythonCode += "                              minimum_leaf_size=3)\r\n";
pythonCode += 'random_forest = output["output_model"]\r\n\r\n';
pythonCode += "# Predict the labels of the test points.\r\n";
pythonCode += "output = mlpack.random_forest(input_model=random_forest,\r\n";
pythonCode += "                              test=test_set)\r\n\r\n";
pythonCode +=
  '# Now print the accuracy.  The "probabilities" output could also be used\r\n';
pythonCode += "# to generate an ROC curve.\r\n";
pythonCode += "correct = np.sum(\r\n";
pythonCode +=
  '    output["predictions"] == np.reshape(test_labels, (test_labels.shape[0],)))\r\n';
pythonCode +=
  'print(str(correct) + " correct out of " + str(len(test_labels)) + " (" + \r\n';
pythonCode +=
  '    str(100 * float(correct) / float(len(test_labels))) + "%).")\r\n';

juliaCode = "";
juliaCode = "using mlpack\r\n\r\n";
juliaCode += "x = rand(5, 5);\r\n";
juliaCode += 'print("Input data:\\n", x)\r\n\r\n';
juliaCode += 'print("\\nPerforming PCA on dataset.")\r\n';
juliaCode += "y = mlpack.pca(x, new_dimensionality=5)\r\n\r\n";
juliaCode += 'print("\\nPCA result:\\n", y)\r\n';
