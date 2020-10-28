stable linux (debian) apt c++
apt install libmlpack-dev mlpack-bin libarmadillo-dev !!# Simple compiler command ! g++ code.cpp -larmadillo -lmlpack

stable linux (debian) apt julia
apt install libmlpack-dev mlpack-bin !! # In Julia ! using mlpack 

stable linux (debian) apt python
apt install libmlpack-dev mlpack-bin !! # In Python ! import mlpack

stable linux (debian) apt all
apt install libmlpack-dev mlpack-bin libarmadillo-dev python3-mlpack

stable linux (debian) pip python
pip install mlpack !! # In Python ! import mlpack

stable linux (debian) conda python
conda install -c conda-forge mlpack !! # In Python ! import mlpack

stable linux (debian) source c++
apt-get install libboost-math-dev libboost-program-options-dev libboost-test-dev libboost-serialization-dev libarmadillo-dev binutils-dev libensmallen-dev libstb-dev wget !! wget -c http://mlpack.org/files/mlpack-latest.tar.gz -O - | tar -xz ! cd mlpack ! mkdir build ! cmake .. ! make ! make install !! # Simple compiler command ! g++ code.cpp -larmadillo -lmlpack

stable linux (debian) source python
apt-get install libboost-math-dev libboost-program-options-dev libboost-test-dev libboost-serialization-dev libarmadillo-dev binutils-dev libensmallen-dev libstb-dev python-pandas python-numpy cython python-setuptools wget !! wget -c http://mlpack.org/files/mlpack-latest.tar.gz -O - | tar -xz ! cd mlpack ! mkdir build ! cmake -DBUILD_PYTHON_BINDINGS=ON .. ! make ! make install !! # In Python ! import mlpack 

stable linux (debian) source julia
apt-get install libboost-math-dev libboost-program-options-dev libboost-test-dev libboost-serialization-dev libarmadillo-dev binutils-dev libensmallen-dev libstb-dev wget !! wget -c http://mlpack.org/files/mlpack-latest.tar.gz -O - | tar -xz ! cd mlpack ! mkdir build ! cmake -DBUILD_JULIA_BINDINGS=ON .. ! make ! make install !! # In Julia ! using mlpack

stable linux (debian) source all
apt-get install libboost-math-dev libboost-program-options-dev libboost-test-dev libboost-serialization-dev libarmadillo-dev binutils-dev libensmallen-dev libstb-dev python-pandas python-numpy cython python-setuptools wget !! wget -c http://mlpack.org/files/mlpack-latest.tar.gz -O - | tar -xz ! cd mlpack ! mkdir build ! cmake -DBUILD_PYTHON_BINDINGS=ON -DBUILD_JULIA_BINDINGS=ON .. ! make ! make install 

stable linux (debian) conda c++
conda install -c conda-forge mlpack !! # Simple compiler command ! g++ code.cpp -larmadillo -lmlpack 

stable linux (debian) pkg.jil julia
# In Julia ! import Pkg; ! Pkg.add("mlpack") 

stable macos brew c++
brew install mlpack !! # Simple compiler command ! g++ code.cpp -larmadillo -lmlpack

stable macos pkg.jil julia
# In Julia ! import Pkg; ! Pkg.add("mlpack")
 
stable macos source c++
brew install boost armadillo ! wget -c http://mlpack.org/files/mlpack-latest.tar.gz -O - | tar -xz ! cd mlpack ! cd mlpack ! mkdir build ! cmake .. ! make ! make install !! # Simple compiler command ! clang++ code.cpp -larmadillo -lmlpack

stable macos source julia
brew install boost armadillo ! wget -c http://mlpack.org/files/mlpack-latest.tar.gz -O - | tar -xz ! cd mlpack ! cd mlpack ! mkdir build ! cmake -DBUILD_JULIA_BINDINGS=ON .. ! make ! make install !! # In Julia ! using mlpack

stable macos source python
brew install boost armadillo ! pip install numpy pandas cython ! wget -c http://mlpack.org/files/mlpack-latest.tar.gz -O - | tar -xz ! cd mlpack ! cd mlpack ! mkdir build ! cmake -DBUILD_PYTHON_BINDINGS=ON .. ! make ! make install !! # In Python ! import mlpack

stable windows msi c++
# See https://www.mlpack.org/doc/mlpack-3.4.2/doxygen/build_windows.html

stable windows source c++
# See https://www.mlpack.org/doc/stable/doxygen/build_windows.html

nightly linux (debian) source c++
apt-get install libboost-math-dev libboost-program-options-dev libboost-test-dev libboost-serialization-dev libarmadillo-dev binutils-dev libensmallen-dev libstb-dev wget git !! git clone https://github.com/mlpack/mlpack.git ! cd mlpack ! mkdir build ! cmake .. ! make ! make install !! # Simple compiler command ! g++ code.cpp -larmadillo -lmlpack

nightly linux (debian) source python
apt-get install libboost-math-dev libboost-program-options-dev libboost-test-dev libboost-serialization-dev libarmadillo-dev binutils-dev libensmallen-dev libstb-dev python-pandas python-numpy cython python-setuptools wget git !! git clone https://github.com/mlpack/mlpack.git ! cd mlpack ! mkdir build ! cmake -DBUILD_PYTHON_BINDINGS=ON .. ! make ! make install !! # In Python ! import mlpack 

nightly linux (debian) source julia
apt-get install libboost-math-dev libboost-program-options-dev libboost-test-dev libboost-serialization-dev libarmadillo-dev binutils-dev libensmallen-dev libstb-dev wget git !! git clone https://github.com/mlpack/mlpack.git ! cd mlpack ! mkdir build ! cmake -DBUILD_JULIA_BINDINGS=ON .. ! make ! make install !! # In Julia ! using mlpack

nightly linux (debian) source all
apt-get install libboost-math-dev libboost-program-options-dev libboost-test-dev libboost-serialization-dev libarmadillo-dev binutils-dev libensmallen-dev libstb-dev python-pandas python-numpy cython python-setuptools wget git !! git clone https://github.com/mlpack/mlpack.git ! cd mlpack ! mkdir build ! cmake -DBUILD_PYTHON_BINDINGS=ON -DBUILD_JULIA_BINDINGS=ON .. ! make ! make install 
