/**
 * @file print_doc.cpp
 * @author Ryan Curtin
 *
 * A utility file to print Python documentation as HTML.
 *
 * Set DIR_NAME and METHOD_NAME with the preprocessor during compilation.
 */
#include <mlpack/core.hpp>
#define BINDING_TYPE BINDING_TYPE_PYX
#include <mlpack/core/util/mlpack_main.hpp>
#include <mlpack/methods/DIR_NAME/METHOD_NAME_main.cpp>

const std::string functionName = "METHOD_NAME";

using namespace mlpack;
using namespace mlpack::util;
using namespace std;

std::string GetPythonType(const util::ParamData& d)
{
  if (d.cppType == "bool")
    return "bool";
  else if (d.cppType == "std::string")
    return "string";
  else if (d.cppType == "int")
    return "int";
  else if (d.cppType == "double")
    return "float";
  else if (d.cppType == "arma::mat")
    return "numpy matrix or arraylike, float dtype";
  else if (d.cppType == "arma::rowvec")
    return "numpy vector or array, float dtype";
  else if (d.cppType == "arma::vec")
    return "numpy vector or array, float dtype";
  else if (d.cppType == "arma::Mat<size_t>")
    return "numpy matrix or arraylike, int/long dtype";
  else if (d.cppType == "arma::Row<size_t>")
    return "numpy vector or array, int/long dtype";
  else if (d.cppType == "arma::Col<size_t>")
    return "numpy vector or array, int/long dtype";
  else if (d.cppType == "std::tuple<mlpack::data::DatasetInfo, arma::mat>")
    return "pandas categorical matrix or numpy matrix or arraylike";
  else
  {
    std::string type = d.cppType;
    type.erase(std::remove(type.begin(), type.end(), '<'), type.end());
    type.erase(std::remove(type.begin(), type.end(), '>'), type.end());
    return "mlpack." + type + "Type";
  }
}

std::string GetPythonOutputType(const util::ParamData& d)
{
  if (d.cppType == "bool")
    return "bool";
  else if (d.cppType == "std::string")
    return "string";
  else if (d.cppType == "int")
    return "int";
  else if (d.cppType == "double")
    return "float";
  else if (d.cppType == "arma::mat")
    return "numpy matrix, float dtype";
  else if (d.cppType == "arma::rowvec")
    return "numpy vector, float dtype";
  else if (d.cppType == "arma::vec")
    return "numpy vector, float dtype";
  else if (d.cppType == "arma::Mat<size_t>")
    return "numpy matrix, int dtype";
  else if (d.cppType == "arma::Row<size_t>")
    return "numpy vector, int dtype";
  else if (d.cppType == "arma::Col<size_t>")
    return "numpy vector, int dtype";
  else if (d.cppType == "std::tuple<mlpack::data::DatasetInfo, arma::mat>")
    return "pandas categorical matrix or numpy matrix or arraylike";
  else
  {
    std::string type = d.cppType;
    type.erase(std::remove(type.begin(), type.end(), '<'), type.end());
    type.erase(std::remove(type.begin(), type.end(), '>'), type.end());
    return "mlpack." + type + "Type";
  }
}

int main()
{
  CLI::RestoreSettings(bindings::python::programName);

  const std::map<std::string, util::ParamData>& parameters = CLI::Parameters();
  typedef std::map<std::string, util::ParamData>::const_iterator ParamIter;

  // First print the header.
  cout << "<h1><center>mlpack." << functionName << "</center></h1>" << endl;

  cout << "<font class=\"titlecode\">" << functionName << "(...)" << "</font><br />"
      << endl;
  cout << "<font class=\"titlebold\">" << CLI::GetSingleton().doc->programName
      << "</font>" << endl;
  cout << "<p class=\"importcode\">&gt;&gt;&gt; from mlpack import " <<
functionName << "</p>";

  // Now we need to actually print the documentation.  Whenever there is a
  // newline, we need a new paragraph.
  bool needsNewP = true;
  bool inCode = false;
  bool inCodeWord = false;
  const std::string documentation = CLI::GetSingleton().doc->documentation();
  for (size_t i = 0; i < documentation.size(); ++i)
  {
    if (documentation[i] == '\n')
    {
      if (inCode)
      {
        // Check the next three characters.
        if (i + 3 < documentation.size() &&
            documentation[i + 1] == '>' &&
            documentation[i + 2] == '>' &&
            documentation[i + 3] == '>')
        {
          cout << "<br />\n";
        }
        else if (i + 2 < documentation.size() &&
                 documentation[i + 1] == ' ' &&
                 documentation[i + 2] == ' ')
        {
          cout << "<br />\n&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
        }
        else
        {
          inCode = false;
          cout << "</font></p>\n";
          needsNewP = true;
        }
      }
      else
      {
        cout << "</p>\n";
        needsNewP = true;
      }
    }
    else if (documentation[i] == '>')
    {
      if (!inCode && i + 2 < documentation.size() &&
          documentation[i + 1] == '>' &&
          documentation[i + 2] == '>')
      {
        inCode = true;
        if (needsNewP)
        {
          cout << "<p class=\"codeblock\">";
          needsNewP = false;
        }
        cout << "<font class=\"code\">";
      }
      else if (needsNewP)
      {
        cout << "<p>";
        needsNewP = false;
      }

      cout << "&gt;";
    }
    else if (documentation[i] == '\'')
    {
      if (needsNewP)
      {
        cout << "<p>";
        needsNewP = false;
      }

      // Any quoted word should be printed as code.
      if (!inCode && i >= 1 && documentation[i - 1] == ' ')
      {
        cout << "<font class=\"code\">'";
        inCodeWord = true;
      }
      else if (!inCode && i >= 1 && inCodeWord)
      {
        cout << "'</font>";
      }
      else
      {
        cout << "'";
      }
    }
    else
    {
      if (needsNewP)
      {
        cout << "<p>";
        needsNewP = false;
      }

      cout << documentation[i];
    }
  }
  if (inCode)
    cout << "</font>";
  cout << "</p>";

  // Now make a section for input options.
  cout << "<h2>input options</h2>" << endl;

  cout << "<ul>" << endl;

  // Print required options first.
  for (ParamIter it = parameters.begin(); it != parameters.end(); ++it)
  {
    const util::ParamData& d = it->second;
    if (d.input && d.required)
    {
      cout << "<li><font class=\"code\">";
      if (d.name == "lambda")
        cout << "lambda_";
      else
        cout << d.name;
      cout << "</font> ";
      cout << "<font class=\"codetype\">(" << GetPythonType(d) << ")</font>:";
      cout << " <font class=\"required\">[required]</font>";

      cout << " " << d.desc;
      if (d.cppType == "std::string")
      {
        cout << "  Default value " << boost::any_cast<std::string>(d.value)
            << ".";
      }
      else if (d.cppType == "double")
      {
        cout << "  Default value " << boost::any_cast<double>(d.value) << ".";
      }
      else if (d.cppType == "int")
      {
        cout << "  Default value " << boost::any_cast<int>(d.value) << ".";
      }
      cout << "</li>";
    }
  }

  for (ParamIter it = parameters.begin(); it != parameters.end(); ++it)
  {
    const util::ParamData& d = it->second;
    if (d.input && !d.required && d.name != "help" && d.name != "info")
    {
      cout << "<li><font class=\"code\">";
      if (d.name == "lambda")
        cout << "lambda_";
      else
        cout << d.name;
      cout << "</font> ";
      cout << "<font class=\"codetype\">(" << GetPythonType(d) << ")</font>:";

      cout << " " << d.desc;
      if (d.cppType == "std::string")
      {
        cout << "  Default value " << boost::any_cast<std::string>(d.value)
            << ".";
      }
      else if (d.cppType == "double")
      {
        cout << "  Default value " << boost::any_cast<double>(d.value) << ".";
      }
      else if (d.cppType == "int")
      {
        cout << "  Default value " << boost::any_cast<int>(d.value) << ".";
      }
      cout << "</li>";
    }
  }

  cout << "</ul>" << endl;

  cout << "<h2>output options</h2>" << endl;

  cout << "<p>The return value from the binding is a dict containing the "
      << "following elements:</p>" << endl;
  cout << "<ul>";

  for (ParamIter it = parameters.begin(); it != parameters.end(); ++it)
  {
    const util::ParamData& d = it->second;
    if (!d.input)
    {
      cout << "<li><font class=\"code\">";
      if (d.name == "lambda")
        cout << "lambda_";
      else
        cout << d.name;
      cout << "</font> ";
      cout << "<font class=\"codetype\">(" << GetPythonOutputType(d)
          << ")</font>: " << d.desc;
      cout << "</li>";
    }
  }
  cout << "<ul>" << endl;

  cout << "</ul>" << endl;
}
