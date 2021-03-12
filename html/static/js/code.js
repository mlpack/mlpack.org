var cppCode = "";
cppCode =
  "// This is an interactive demo, so feel free to change the code and click the 'Run' button.\r\n\r\n";
cppCode +=
  "// This simple program uses the mlpack::neighbor::NeighborSearch object\r\n";
cppCode +=
  "// to find the nearest neighbor of each point in a dataset using the L1 metric,\r\n";
cppCode +=
  "// and then print the index of the neighbor and the distance of it to stdout.\r\n\r\n";
cppCode += "#include <mlpack/core.hpp>\r\n";
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
pythonCode =
  "# This is an interactive demo, so feel free to change the code and click the 'Run' button.\r\n\r\n";
pythonCode +=
  "# Simple classification on a subset of the standard machine learning covertype dataset.\r\n";
pythonCode +=
  "# We'll first split the dataset into a training set and a testing set, then we'll train\r\n";
pythonCode +=
  "# an mlpack Random Forest on the training data, and finally we'll print the accuracy of\r\n";
pythonCode += "# the random forest on the test dataset.\r\n\r\n";
pythonCode += "import mlpack\r\n";
pythonCode += "import pandas as pd\r\n";
pythonCode += "import numpy as np\r\n\r\n";
pythonCode +=
  '# Load the dataset from an online URL.  Replace with "covertype.csv.gz" if you\r\n';
pythonCode += "# want to use on the full dataset.\r\n";
pythonCode +=
  'df = pd.read_csv("https://www.mlpack.org/datasets/covertype-small.csv.gz")\r\n\r\n';
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
juliaCode =
  "# This is an interactive demo, so feel free to change the code and click the 'Run' button.\r\n\r\n";
juliaCode +=
  "# This is a simple example of how to use the mlpack Principal Component Analysis method on a random dataset.\r\n\r\n";
juliaCode += "using mlpack\r\n\r\n";
juliaCode += "x = rand(5, 5);\r\n";
juliaCode += 'print("Input data:\\n", x)\r\n\r\n';
juliaCode += 'print("\\nPerforming PCA on dataset.")\r\n';
juliaCode += "y = mlpack.pca(x, new_dimensionality=5)\r\n\r\n";
juliaCode += 'print("\\nPCA result:\\n", y)\r\n';

goCode = "";
goCode =
  "// This is an interactive demo, so feel free to change the code and click the 'Run' button.\r\n\r\n";
goCode +=
  "// Simple classification on a subset of the standard machine learning covertype dataset.\r\n";
goCode +=
  "// We'll first split the dataset into a training set and a testing set, then we'll train\r\n";
goCode +=
  "// an mlpack Random Forest on the training data, and finally we'll print the accuracy of\r\n";
goCode += "// the random forest on the test dataset.\r\n\r\n";
goCode += "package main\r\n\r\n";
goCode += "import (\r\n";
goCode += '  "mlpack.org/v1/mlpack"\r\n';
goCode += '  "fmt"\r\n';
goCode += ")\r\n";
goCode += "func main() {\r\n";
goCode += "  // Download dataset.\r\n";
goCode +=
  '  mlpack.DownloadFile("https://www.mlpack.org/datasets/covertype-small.data.csv.gz",\r\n';
goCode += '                      "data.csv.gz")\r\n';
goCode +=
  '  mlpack.DownloadFile("https://www.mlpack.org/datasets/covertype-small.labels.csv.gz",\r\n';
goCode += '                      "labels.csv.gz")\r\n\r\n';
goCode += "  // Extract/Unzip the dataset.\r\n";
goCode += '  mlpack.UnZip("data.csv.gz", "data.csv")\r\n';
goCode += '  dataset, _ := mlpack.Load("data.csv")\r\n\r\n';
goCode += '  mlpack.UnZip("labels.csv.gz", "labels.csv")\r\n';
goCode += '  labels, _ := mlpack.Load("labels.csv")\r\n\r\n';
goCode += "  // Split the dataset using mlpack.\r\n";
goCode += "  params := mlpack.PreprocessSplitOptions()\r\n";
goCode += "  params.InputLabels = labels\r\n";
goCode += "  params.TestRatio = 0.3\r\n";
goCode += "  params.Verbose = true\r\n";
goCode += "  test, test_labels, train, train_labels :=\r\n";
goCode += "      mlpack.PreprocessSplit(dataset, params)\r\n\r\n";
goCode += "  // Train a random forest.\r\n";
goCode += "  rf_params := mlpack.RandomForestOptions()\r\n";
goCode += "  rf_params.NumTrees = 10\r\n";
goCode += "  rf_params.MinimumLeafSize = 3\r\n";
goCode += "  rf_params.PrintTrainingAccuracy = true\r\n";
goCode += "  rf_params.Training = train\r\n";
goCode += "  rf_params.Labels = train_labels\r\n";
goCode += "  rf_params.Verbose = true\r\n";
goCode += "  rf_model, _, _ := mlpack.RandomForest(rf_params)\r\n\r\n";
goCode += "  // Predict the labels of the test points.\r\n";
goCode += "  rf_params_2 := mlpack.RandomForestOptions()\r\n";
goCode += "  rf_params_2.Test = test\r\n";
goCode += "  rf_params_2.InputModel = &rf_model\r\n";
goCode += "  rf_params_2.Verbose = true\r\n";
goCode += "  _, predictions, _ := mlpack.RandomForest(rf_params_2)\r\n\r\n";
goCode += "  // Now print the accuracy.\r\n";
goCode += "  rows, _ := predictions.Dims()\r\n";
goCode += "  var sum int = 0\r\n";
goCode += "  for i := 0; i < rows; i++ {\r\n";
goCode += "    if (predictions.At(i, 0) == test_labels.At(i, 0)) {\r\n";
goCode += "      sum = sum + 1\r\n";
goCode += "    }\r\n";
goCode += "  }\r\n";
goCode += '  fmt.Print(sum, " correct out of ", rows, " (",\r\n';
goCode += '      (float64(sum) / float64(rows)) * 100, "%).")\r\n';
goCode += "}\r\n";

shCode = "";
shCode =
  "# This is an interactive demo, so feel free to change the code and click the 'Run' button.\r\n\r\n";
shCode +=
  "# Simple example of how to use mlpack from the command-line, let's do some simple\r\n";
shCode +=
  "# classification on a subset of the standard machine learning covertype dataset.\r\n";
shCode +=
  "# We'll first split the dataset into a training set and a testing set, then we'll\r\n";
shCode +=
  "# train an mlpack random forest on the training data, and finally we'll print the accuracy\r\n";
shCode += "# of the random forest on the test dataset.\r\n\r\n";
shCode += "# Get the dataset and unpack it.\r\n";
shCode +=
  "wget -q https://www.mlpack.org/datasets/covertype-small.data.csv.gz\r\n";
shCode +=
  "wget -q https://www.mlpack.org/datasets/covertype-small.labels.csv.gz\r\n";
shCode +=
  "gunzip -f covertype-small.data.csv.gz covertype-small.labels.csv.gz\r\n\r\n";
shCode +=
  "# Split the dataset; 70% into a training set and 30% into a test set.\r\n";
shCode +=
  "# Each of these options has a shorthand single-character option but here we type\r\n";
shCode += "# it all out for clarity.\r\n";
shCode +=
  "mlpack_preprocess_split                                       \\\r\n";
shCode +=
  "    --input_file covertype-small.data.csv                     \\\r\n";
shCode +=
  "    --input_labels_file covertype-small.labels.csv            \\\r\n";
shCode +=
  "    --training_file covertype-small.train.csv                 \\\r\n";
shCode +=
  "    --training_labels_file covertype-small.train.labels.csv   \\\r\n";
shCode +=
  "    --test_file covertype-small.test.csv                      \\\r\n";
shCode +=
  "    --test_labels_file covertype-small.test.labels.csv        \\\r\n";
shCode +=
  "    --test_ratio 0.3                                          \\\r\n";
shCode += "    --verbose\r\n\r\n";
shCode += "# Train a random forest.\r\n";
shCode += "mlpack_random_forest                                  \\\r\n";
shCode += "    --training_file covertype-small.train.csv         \\\r\n";
shCode += "    --labels_file covertype-small.train.labels.csv    \\\r\n";
shCode += "    --num_trees 10                                    \\\r\n";
shCode += "    --minimum_leaf_size 3                             \\\r\n";
shCode += "    --print_training_accuracy                         \\\r\n";
shCode += "    --output_model_file rf-model.bin                  \\\r\n";
shCode += "    --verbose\r\n\r\n";
shCode +=
  "# Now predict the labels of the test points and print the accuracy.\r\n";
shCode +=
  "# Also, save the test set predictions to the file 'predictions.csv'.\r\n";
shCode += "mlpack_random_forest                                    \\\r\n";
shCode += "    --input_model_file rf-model.bin                     \\\r\n";
shCode += "    --test_file covertype-small.test.csv                \\\r\n";
shCode += "    --test_labels_file covertype-small.test.labels.csv  \\\r\n";
shCode += "    --predictions_file predictions.csv                  \\\r\n";
shCode += "    --verbose\r\n\r\n";
shCode += "cat predictions.csv\r\n";
