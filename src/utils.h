#ifndef UTILS_H_
#define UTILS_H_

#include <boost/filesystem.hpp>
#include <string>

#include "json/json.h"

struct Utils {
  static std::string fromBase64(std::string);
  static std::string toBase64(const std::string &);
  static void hex2bin(const std::string hexstring, unsigned char *binout);
  static Json::Value parseJSON(const std::string &json_str);
  static Json::Value parseJSONFile(const boost::filesystem::path &filename);
  static std::string intToString(unsigned int val);
  static std::string genPrettyName();
  static std::string readFile(const boost::filesystem::path &filename);
  static void writeFile(const boost::filesystem::path &filename, const std::string &content,
                        bool create_directories = true);
  static void writeFile(const boost::filesystem::path &filename, const Json::Value &content,
                        bool create_directories = true);
  static void copyDir(const boost::filesystem::path &from, const boost::filesystem::path &to);
  static Json::Value getHardwareInfo();
  static std::string getHostname();
  static std::string randomUuid();
  static int shell(const std::string &command, std::string *output);
  static boost::filesystem::path absolutePath(const boost::filesystem::path &root, const boost::filesystem::path &file);
};

/**
 * RAII Temporary file creation
 */
class TemporaryFile : boost::noncopyable {
 public:
  TemporaryFile(const std::string &hint = "file");
  ~TemporaryFile();
  void PutContents(const std::string &contents);
  boost::filesystem::path Path() const;
  std::string PathString() const;

 private:
  boost::filesystem::path tmp_name_;
};

class TemporaryDirectory : boost::noncopyable {
 public:
  TemporaryDirectory(const std::string &hint = "dir");
  ~TemporaryDirectory();
  boost::filesystem::path Path() const;
  std::string PathString() const;
  boost::filesystem::path operator/(const boost::filesystem::path &subdir) const;

 private:
  boost::filesystem::path tmp_name_;
};

#endif  // UTILS_H_
