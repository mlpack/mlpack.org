Name:           mlpack
Version:        1.0.1
Release:        5%{?dist}
Summary:        Scalable, fast C++ machine learning library

Group:          System Environment/Libraries
License:        LGPLv3+
URL:            http://www.mlpack.org
Source0:        http://www.mlpack.org/files/%{name}-%{version}.tar.gz

# CMake by default doesn't provide support for specifying libdir on install
# (argh!) and this has to be done by hand in the CMake configuration.  This'll
# be fixed by mlpack 1.0.2.
Patch0:         cmake_libdir.patch

# Oversight means that the rule which says "install range_search to bin/" didn't
# get there.
Patch1:         range_search_install.patch

# The GetKernelMatrix patch fixes a bug where a function was called before
# it was ever declared.  This isn't a problem in certain GCC settings, but
# in the Fedora setting it throws an error (which is easily fixed by that
# patch).  Fixed upstream in trunk (not 1.0.1).
Patch2:         getkernelmatrix_definition.patch

# More recent Armadillo versions require specific calls to arma::as_scalar().
# Fixed upstream in trunk (not 1.0.1).
Patch3:         fully_qualified_as_scalar.patch

# The hacked-in sparse support for Armadillo in mlpack 1.0.1 does not work with
# recent Armadillo versions.  That support becomes irrelevant with the
# impending 3.4 release so the issue is not fixed in trunk due to its pending
# obsolescence.
Patch4:         no_sparse_tests.patch

BuildRoot:      %{_tmppath}/%{name}-%{version}-%{release}-root-%(%{__id_u} -n)

BuildRequires:  cmake >= 2.8.0
# 2.4.0 precipitated an internal Armadillo switch from 'u32' to 'uword' and the
# Armadillo extensions in mlpack depend on the use of 'uword' which is
# undefined <= 2.4.0.
BuildRequires:  armadillo-devel >= 2.4.0
BuildRequires:  libxml2-devel
BuildRequires:  boost-devel, boost-program-options, boost-math
BuildRequires:  lapack-devel
# For generating man pages (CMake configuration takes care of this assuming
# txt2man is installed).  It is possible that we could just add all the man
# pages, generated offline, as a patch to this SRPM, but txt2man seems to exist
# in repos.
BuildRequires:  txt2man
# For generation of Doxygen HTML documentation.
BuildRequires:  doxygen

%description
mlpack is a C++ machine learning library with emphasis on scalability, speed,
and ease-of-use. Its aim is to make machine learning possible for novice users
by means of a simple, consistent API, while simultaneously exploiting C++
language features to provide maximum performance and maximum flexibility for
expert users. mlpack outperforms competing machine learning libraries by large
margins.

# Executables.
%package bin
Summary:        Command-line executables for mlpack (machine learning library)
Group:          Applications/Engineering
Requires:       %{name}%{_isa} = %{version}-%{release}

%description bin
mlpack is a C++ machine learning library with emphasis on scalability, speed,
and ease-of-use. Its aim is to make machine learning possible for novice users
by means of a simple, consistent API, while simultaneously exploiting C++
language features to provide maximum performance and maximum flexibility for
expert users. mlpack outperforms competing machine learning libraries by large
margins.  This package provides the command-line executables which run mlpack
methods and related documentation.

# Development headers.
%package devel
Summary:        Development headers for mlpack (C++ machine learning library)
Group:          System Environment/Libraries
Requires:       %{name} = %{version}-%{release}
Requires:       armadillo-devel >= 2.4.0
Requires:       boost-devel, boost-program-options, boost-math
Requires:       libxml2-devel
Requires:       lapack-devel

%description devel
mlpack is a C++ machine learning library with emphasis on scalability, speed,
and ease-of-use. Its aim is to make machine learning possible for novice users
by means of a simple, consistent API, while simultaneously exploiting C++
language features to provide maximum performance and maximum flexibility for
expert users. mlpack outperforms competing machine learning libraries by large
margins.  This package provides the headers to compile applications against
mlpack.



%package doc
Summary:        Doxygen documentation for mlpack (C++ machine learning library)
Group:          Documentation

%description doc
mlpack is a C++ machine learning library with emphasis on scalability, speed,
and ease-of-use.  Its aim is to make machine learning possible for novice users
by means of a simple, consistent API, while simultaneously exploiting C++
language features to provide maximum performance and maximum flexibility for
expert users.  mlpack outperforms competing machine learning libraries by large
margins.  This package provides the Doxygen-generated documentation for mlpack.


%prep
%setup -q
%patch0 -p1
%patch1 -p1
%patch2 -p1
%patch3 -p1
%patch4 -p1


%build
%{cmake} -D LIBDIR=%{_libdir} -D DEBUG=OFF -D PROFILE=OFF .
make %{?_smp_mflags}
# Build documentation ('doc' is not in the list of default targets).
make doc


%install
rm -rf $RPM_BUILD_ROOT
make install DESTDIR=$RPM_BUILD_ROOT

# Rename executables to mlpack_* to avoid possible naming collisions.  Upstream
# bug report http://trac.research.cc.gatech.edu/fastlab/ticket/236.
for i in `ls $RPM_BUILD_ROOT/%{_bindir}`
do
  %{__mv} $RPM_BUILD_ROOT/%{_bindir}/$i $RPM_BUILD_ROOT/%{_bindir}/mlpack_$i;
done
for i in `ls $RPM_BUILD_ROOT/%{_mandir}/man1`
do
  %{__mv} $RPM_BUILD_ROOT/%{_mandir}/man1/$i $RPM_BUILD_ROOT/%{_mandir}/man1/mlpack_$i;
done

%clean
rm -rf $RPM_BUILD_ROOT

%post -p /sbin/ldconfig

%postun -p /sbin/ldconfig


%files
%defattr(-,root,root,-)
%{_libdir}/libmlpack.so.1
%{_libdir}/libmlpack.so.1.0.1
%doc LICENSE.txt

%files bin
%defattr(-,root,root,-)
%{_bindir}/mlpack_allknn
%{_bindir}/mlpack_allkfn
%{_bindir}/mlpack_emst
%{_bindir}/mlpack_gmm
%{_bindir}/mlpack_hmm_generate
%{_bindir}/mlpack_hmm_loglik
%{_bindir}/mlpack_hmm_train
%{_bindir}/mlpack_hmm_viterbi
%{_bindir}/mlpack_kernel_pca
%{_bindir}/mlpack_kmeans
%{_bindir}/mlpack_lars
%{_bindir}/mlpack_linear_regression
%{_bindir}/mlpack_local_coordinate_coding
%{_bindir}/mlpack_nbc
%{_bindir}/mlpack_nca
%{_bindir}/mlpack_pca
%{_bindir}/mlpack_radical
%{_bindir}/mlpack_range_search
%{_bindir}/mlpack_sparse_coding
%{_mandir}/man1/mlpack_allknn.1*
%{_mandir}/man1/mlpack_allkfn.1*
%{_mandir}/man1/mlpack_emst.1*
%{_mandir}/man1/mlpack_gmm.1*
%{_mandir}/man1/mlpack_hmm_generate.1*
%{_mandir}/man1/mlpack_hmm_loglik.1*
%{_mandir}/man1/mlpack_hmm_train.1*
%{_mandir}/man1/mlpack_hmm_viterbi.1*
%{_mandir}/man1/mlpack_kernel_pca.1*
%{_mandir}/man1/mlpack_kmeans.1*
%{_mandir}/man1/mlpack_lars.1*
%{_mandir}/man1/mlpack_linear_regression.1*
%{_mandir}/man1/mlpack_local_coordinate_coding.1*
%{_mandir}/man1/mlpack_nbc.1*
%{_mandir}/man1/mlpack_nca.1*
%{_mandir}/man1/mlpack_pca.1*
%{_mandir}/man1/mlpack_radical.1*
%{_mandir}/man1/mlpack_range_search.1*
%{_mandir}/man1/mlpack_sparse_coding.1*

%files devel
%defattr(-,root,root,-)
%{_libdir}/libmlpack.so
%{_includedir}/mlpack/

%files doc
%defattr(-,root,root,-)
%{_docdir}/mlpack/

%changelog
* Tue Sep 26 2012 Ryan Curtin <gth671b@mail.gatech.edu> - 1.0.1-5
- Simplify LICENSE.txt installation.
- Install doxygen documentation.

* Sun Sep 16 2012 Ryan Curtin <gth671b@mail.gatech.edu> - 1.0.1-4
- Distribute LICENSE.txt.

* Sun Jul 29 2012 Ryan Curtin <gth671b@mail.gatech.edu> - 1.0.1-3
- Fix group names for packages.
- Comment patches more verbosely.
- Rename exectuables to mlpack_* to avoid possible naming conflicts.

* Thu Jul 21 2012 Sterling Lewis Peet <sterling.peet@gatech.edu> - 1.0.1-2
- Include GetKernelMatrix patch so that mlpack builds using fedora flags.

* Thu Mar 08 2012 Ryan Curtin <gth671b@mail.gatech.edu> - 1.0.1-1
- Initial packaging of mlpack.
