/**
 * @file optimizer.hpp
 * @author Marcus Edel
 */

#include <mlpack/core.hpp>
#include <mlpack/core/util/sfinae_utility.hpp>

#include <mlpack/core/optimizers/adam/adam.hpp>
#include <mlpack/core/optimizers/rmsprop/rmsprop.hpp>
#include <mlpack/core/optimizers/ada_delta/ada_delta.hpp>
#include <mlpack/core/optimizers/ada_grad/ada_grad.hpp>
#include <mlpack/core/optimizers/cne/cne.hpp>
#include <mlpack/core/optimizers/smorms3/smorms3.hpp>
#include <mlpack/core/optimizers/iqn/iqn.hpp>
#include <mlpack/core/optimizers/cmaes/cmaes.hpp>
#include <mlpack/core/optimizers/sgd/sgd.hpp>
#include <mlpack/core/optimizers/lbfgs/lbfgs.hpp>
#include <mlpack/core/optimizers/gradient_descent/gradient_descent.hpp>
#include <mlpack/core/optimizers/sa/sa.hpp>
#include <mlpack/core/optimizers/sa/exponential_schedule.hpp>
#include <mlpack/core/optimizers/spalera_sgd/spalera_sgd.hpp>

#include <mlpack/core/optimizers/problems/booth_function.hpp>
#include <mlpack/core/optimizers/problems/bukin_function.hpp>
#include <mlpack/core/optimizers/problems/drop_wave_function.hpp>
#include <mlpack/core/optimizers/problems/sphere_function.hpp>
#include <mlpack/core/optimizers/problems/rastrigin_function.hpp>
#include <mlpack/core/optimizers/problems/mc_cormick_function.hpp>
#include <mlpack/core/optimizers/problems/easom_function.hpp>
#include <mlpack/core/optimizers/problems/styblinski_tang_function.hpp>
#include <mlpack/core/optimizers/problems/eggholder_function.hpp>

#include <iostream>
#include <sstream>

using namespace arma;
using namespace mlpack::optimization;
using namespace mlpack::optimization::test;


HAS_MEM_FUNC(BatchSize, HasBatchSize);

template<class FunctionType>
class WrapperFunction
{
 public:
  WrapperFunction(FunctionType& function) : function(function) { }

  arma::mat& Coordinates() { return coordinates; }

  void Shuffle() { function.Shuffle(); }

  size_t NumFunctions() const { return function.NumFunctions(); }

  arma::mat GetInitialPoint() const { return function.GetInitialPoint(); }

  double Evaluate(const arma::mat& coordinates,
                  const size_t begin,
                  const size_t batchSize)
  {
    const double result = function.Evaluate(coordinates, begin, batchSize);

    coordinatesHistory.push_back(coordinates);
    evaluateHistory.push_back(result);

    return result;
  }

  double Evaluate(const arma::mat& coordinates)
  {
    const double result = function.Evaluate(coordinates);

    coordinatesHistory.push_back(coordinates);
    evaluateHistory.push_back(result);

    return result;
  }

  void Gradient(const arma::mat& coordinates,
                const size_t begin,
                arma::mat& gradient,
                const size_t batchSize)
  {
    function.Gradient(coordinates, begin, gradient, batchSize);
  }

  void Gradient(const arma::mat& coordinates, arma::mat& gradient)
  {
    function.Gradient(coordinates, gradient);
  }

  void Save(arma::mat& data)
  {
    data = arma::zeros(coordinatesHistory[0].n_elem + 2,
        coordinatesHistory.size());
    for (size_t i = 0; i < coordinatesHistory.size(); ++i)
    {
      data(0, i) = i;
      data.submat(1, i, 2, i) = coordinatesHistory[i];
      data(data.n_rows - 1, i) = evaluateHistory[i];
    }
  }

 private:
  FunctionType& function;
  arma::mat coordinates;
  std::vector<arma::mat> coordinatesHistory;
  std::vector<double> evaluateHistory;
};

template<typename T, typename F>
inline typename std::enable_if<
    HasBatchSize<T, size_t&(T::*)()>::value, void>::type
SetBatchSize(T& optimizer, F& function)
{
  optimizer.BatchSize() = function.NumFunctions();
}

template<typename T, typename F>
inline typename std::enable_if<
    !HasBatchSize<T, size_t&(T::*)()>::value, void>::type
SetBatchSize(T& optimizer, F& function)
{
  /* Nothing to do here */
}

template<typename OptimizerType, typename FunctionType>
void OptimizeOptimizer(OptimizerType& optimizer,
                       FunctionType& f)
{
  WrapperFunction<FunctionType> wf(f);

  SetBatchSize(optimizer, f);
  wf.Coordinates() = wf.GetInitialPoint();

  optimizer.Optimize(wf, wf.Coordinates());

  arma::mat coordinates;
  wf.Save(coordinates);

  std::cout.precision(4);
  std::cout.setf(ios::fixed);
  coordinates.t().raw_print(cout);
}


template<typename OptimizerType>
void OptimizeFunction(OptimizerType& optimizer, const size_t functionID)
{
  if (functionID == 0)
  {
    BoothFunction f;
    OptimizeOptimizer(optimizer, f);
  }
  else if (functionID == 1)
  {
    BukinFunction f;
    OptimizeOptimizer(optimizer, f);
  }
  else if (functionID == 2)
  {
    DropWaveFunction f;
    OptimizeOptimizer(optimizer, f);
  }
  else if (functionID == 3)
  {
    SphereFunction f(2);
    OptimizeOptimizer(optimizer, f);
  }
  else if (functionID == 4)
  {
    RastriginFunction f(2);
    OptimizeOptimizer(optimizer, f);
  }
  else if (functionID == 5)
  {
    McCormickFunction f;
    OptimizeOptimizer(optimizer, f);
  }
  else if (functionID == 6)
  {
    EasomFunction f;
    OptimizeOptimizer(optimizer, f);
  }
  else if (functionID == 7)
  {
    StyblinskiTangFunction f(2);
    OptimizeOptimizer(optimizer, f);
  }
  else if (functionID == 8)
  {
    EggholderFunction f;
    OptimizeOptimizer(optimizer, f);
  }
}

int main(void)
{
  char* qs;
  qs = getenv("QUERY_STRING");

  // Some server don't provide QUERY_STRING if it's empty so avoid strdup()'ing
  // a NULL pointer here.
  char* cgiInput = strdup(qs ? qs : "");

  std::string data(cgiInput);

  std::replace(data.begin(), data.end(), '=', ' ');
  std::replace(data.begin(), data.end(), '&', ' ');
  std::stringstream ss(data);

  std::string parameter;
  std::string optimizer;
  size_t functionID;
  size_t iterations;
  double stepSize;
  double parameterA, parameterB, parameterC, parameterD;

  ss >> parameter >> optimizer
     >> parameter >> functionID
     >> parameter >> iterations
     >> parameter >> stepSize
     >> parameter >> parameterA
     >> parameter >> parameterB
     >> parameter >> parameterC
     >> parameter >> parameterD;

  // Data not well-formatted.
  if (ss.fail())
    return 0;

  // Iterations sanity checks.
  if (iterations <= 0 || iterations > 10000)
    return 0;

  std::cout << "Content-type: text/html";
  std::cout << std::endl << std::endl;

  Adam adamOpt(stepSize, 1, parameterA, parameterB, 1e-8, iterations,
      1e-9, false);
  RMSProp rmsPropOpt(stepSize, 1, parameterA, 1e-8, iterations, 1e-9, false);
  AdaDelta adaDeltaOpt(stepSize, 1, parameterA, 1e-8, iterations, 1e-9, false);
  AdaGrad adaGradOpt(stepSize, 1, 1e-8, iterations, 1e-9, false);
  CNE cneOpt(parameterA, iterations, stepSize, parameterB, parameterC, 0.1);
  SMORMS3 smormsOpt(stepSize, 1, 1e-16, iterations, 1e-9, false);
  IQN iqnOpt(stepSize, 1, iterations, 1e-9);
  CMAES<> cmaesOpt(0, parameterA, parameterB, 1, iterations, 1e-9);
  AdaMax adaMaxOpt(stepSize, 1, parameterA, parameterB, 1e-8, iterations,
      1e-9, false);
  AMSGrad amsGradOpt(stepSize, 1, parameterA, parameterB, 1e-8, iterations,
      1e-9, false);
  Nadam nadamOpt(stepSize, 1, parameterA, parameterB, 1e-8, iterations,
      1e-9, false);
  StandardSGD sgdOpt(stepSize, 1, iterations, 1e-9, false);
  MomentumSGD sgdMomentumOpt(stepSize, 1, iterations, 1e-9, false,
      MomentumUpdate(parameterA));
  L_BFGS lbfgsOpt(stepSize, iterations, parameterA, 1e-4, parameterB, 1e-9);
  GradientDescent gdOpt(stepSize, iterations, 1e-9);
  ExponentialSchedule schedule;
  SA<ExponentialSchedule> saOpt(schedule, iterations, stepSize, parameterA,
      parameterB, 1e-9, 3, parameterC, parameterD, 0.3);
  SPALeRASGD<> spalerasgdOpt(stepSize, 1, iterations, 1e-4);

  if (optimizer == "adam")
  {
    OptimizeFunction(adamOpt, functionID);
  }
  else if (optimizer == "rmsprop")
  {
    OptimizeFunction(rmsPropOpt, functionID);
  }
  else if (optimizer == "adadelta")
  {
    OptimizeFunction(adaDeltaOpt, functionID);
  }
  else if (optimizer == "adagrad")
  {
    OptimizeFunction(adaGradOpt, functionID);
  }
  else if (optimizer == "cne")
  {
    OptimizeFunction(cneOpt, functionID);
  }
  else if (optimizer == "smorms")
  {
    OptimizeFunction(smormsOpt, functionID);
  }
  else if (optimizer == "iqn")
  {
    OptimizeFunction(iqnOpt, functionID);
  }
  else if (optimizer == "cmaes")
  {
    OptimizeFunction(cmaesOpt, functionID);
  }
  else if (optimizer == "adamax")
  {
    OptimizeFunction(adaMaxOpt, functionID);
  }
  else if (optimizer == "amsgrad")
  {
    OptimizeFunction(amsGradOpt, functionID);
  }
  else if (optimizer == "nadam")
  {
    OptimizeFunction(nadamOpt, functionID);
  }
  else if (optimizer == "sgd")
  {
    OptimizeFunction(sgdOpt, functionID);
  }
  else if (optimizer == "sgdmomentum")
  {
    OptimizeFunction(sgdMomentumOpt, functionID);
  }
  else if (optimizer == "lbfgs")
  {
    OptimizeFunction(lbfgsOpt, functionID);
  }
  else if (optimizer == "gradientdescent")
  {
    OptimizeFunction(gdOpt, functionID);
  }
  else if (optimizer == "simulatedannealing")
  {
    OptimizeFunction(saOpt, functionID);
  }
  else if (optimizer == "spalerasgd")
  {
    OptimizeFunction(spalerasgdOpt, functionID);
  }

  return 0;
}
