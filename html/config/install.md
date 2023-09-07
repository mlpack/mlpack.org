stable linux (debian) apt c++
apt install libmlpack-dev mlpack-bin libarmadillo-dev !!# Simple compiler command ! g++ code.cpp -larmadillo

stable linux (debian) apt julia
apt install libmlpack-dev mlpack-bin !! # In Julia ! using Pkg ! Pkg.add("mlpack") ! using mlpack

stable linux (debian) apt python
apt install libmlpack-dev mlpack-bin python3-mlpack !! # In Python ! import mlpack

stable linux (debian) apt all
apt install libmlpack-dev mlpack-bin libarmadillo-dev python3-mlpack

stable linux (debian) pip python
pip install mlpack !! # In Python ! import mlpack

stable linux (debian) conda python
conda install -c conda-forge mlpack !! # In Python ! import mlpack

stable linux (debian) source c++
apt-get install libarmadillo-dev libcereal-dev binutils-dev libensmallen-dev libstb-dev wget !! wget -c http://mlpack.org/files/mlpack-4.2.1.tar.gz -O - | tar -xz ! cd mlpack ! mkdir build ! cd build ! cmake .. ! make ! make install !! # Simple compiler command ! g++ code.cpp -larmadillo

stable linux (debian) source python
apt-get install libarmadillo-dev libcereal-dev binutils-dev libensmallen-dev libstb-dev python-pandas python-numpy cython python-setuptools wget !! wget -c http://mlpack.org/files/mlpack-4.2.1.tar.gz -O - | tar -xz ! cd mlpack ! mkdir build ! cd build ! cmake -DBUILD_PYTHON_BINDINGS=ON .. ! make ! make install !! # In Python ! import mlpack

stable linux (debian) source julia
apt-get install libarmadillo-dev libcereal-dev binutils-dev libensmallen-dev libstb-dev wget !! wget -c http://mlpack.org/files/mlpack-4.2.1.tar.gz -O - | tar -xz ! cd mlpack ! mkdir build ! cd build ! cmake -DBUILD_JULIA_BINDINGS=ON .. ! make ! make install !! # In Julia ! using mlpack

stable linux (debian) source all
apt-get install libarmadillo-dev libcereal-dev binutils-dev libensmallen-dev libstb-dev python-pandas python-numpy cython python-setuptools wget !! wget -c http://mlpack.org/files/mlpack-4.2.1.tar.gz -O - | tar -xz ! cd mlpack ! mkdir build ! cd build ! cmake -DBUILD_PYTHON_BINDINGS=ON -DBUILD_JULIA_BINDINGS=ON .. ! make ! make install

stable linux (debian) conda c++
conda install -c conda-forge mlpack !! # Simple compiler command ! g++ code.cpp -larmadillo

stable linux (debian) pkg.jl julia
# In Julia ! import Pkg; ! Pkg.add("mlpack")

stable macos brew c++
brew install mlpack !! # Simple compiler command ! g++ code.cpp -larmadillo

stable macos pkg.jl julia
# In Julia ! import Pkg; ! Pkg.add("mlpack")

stable macos source c++
brew install cereal armadillo ! wget -c http://mlpack.org/files/mlpack-4.2.1.tar.gz -O - | tar -xz ! cd mlpack ! cd mlpack ! mkdir build ! cd build ! cmake .. ! make ! make install !! # Simple compiler command ! clang++ code.cpp -larmadillo

stable macos source julia
brew install cereal armadillo ! wget -c http://mlpack.org/files/mlpack-4.2.1.tar.gz -O - | tar -xz ! cd mlpack ! cd mlpack ! mkdir build ! cd build ! cmake -DBUILD_JULIA_BINDINGS=ON .. ! make ! make install !! # In Julia ! using mlpack

stable macos source python
brew install cereal armadillo ! pip install numpy pandas cython ! wget -c http://mlpack.org/files/mlpack-4.2.1.tar.gz -O - | tar -xz ! cd mlpack ! cd mlpack ! mkdir build ! cd build ! cmake -DBUILD_PYTHON_BINDINGS=ON .. ! make ! make install !! # In Python ! import mlpack

stable windows msi c++
# See https://github.com/mlpack/mlpack/blob/4.2.1/doc/user/build_windows.md

stable windows source c++
# See https://github.com/mlpack/mlpack/blob/4.2.1/doc/user/build_windows.md

nightly linux (debian) source c++
apt-get install libarmadillo-dev libcereal-dev binutils-dev libensmallen-dev libstb-dev wget git !! git clone https://github.com/mlpack/mlpack.git ! cd mlpack ! mkdir build ! cd build ! cmake .. ! make ! make install !! # Simple compiler command ! g++ code.cpp -larmadillo

nightly linux (debian) source python
apt-get install libarmadillo-dev libcereal-dev binutils-dev libensmallen-dev libstb-dev python-pandas python-numpy cython python-setuptools wget git !! git clone https://github.com/mlpack/mlpack.git ! cd mlpack ! mkdir build ! cd build ! cmake -DBUILD_PYTHON_BINDINGS=ON .. ! make ! make install !! # In Python ! import mlpack

nightly linux (debian) source julia
apt-get install libarmadillo-dev libcereal-dev binutils-dev libensmallen-dev libstb-dev wget git !! git clone https://github.com/mlpack/mlpack.git ! cd mlpack ! mkdir build ! cd build ! cmake -DBUILD_JULIA_BINDINGS=ON .. ! make ! make install !! # In Julia ! using mlpack

nightly linux (debian) source all
apt-get install libarmadillo-dev libcereal-dev binutils-dev libensmallen-dev libstb-dev python-pandas python-numpy cython python-setuptools wget git !! git clone https://github.com/mlpack/mlpack.git ! cd mlpack ! mkdir build ! cd build ! cmake -DBUILD_PYTHON_BINDINGS=ON -DBUILD_JULIA_BINDINGS=ON .. ! make ! make install
