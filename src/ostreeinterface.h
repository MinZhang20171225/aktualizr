#ifndef OSTREEINTERFACE_H_
#define OSTREEINTERFACE_H_

#include <string>

#include <boost/shared_ptr.hpp>
#include <glib/gi18n.h>
#include <ostree-1/ostree.h>

#include "config.h"
#include "types.h"

class OstreeInterface {
 public:
  static virtual Json::Value getInstalledPackages(const boost::filesystem::path &file_path);
};

class OstreePackageInterface {
 public:
  virtual OstreePackageInterface(const std::string &branch_name_in, const std::string &refhash_in, const std::string &treehub_in);
  virtual data::InstallOutcome install(const data::PackageManagerCredentials &cred, OstreeConfig config) const;
  virtual Json::Value toEcuVersion(const std::string &ecu_serial, const Json::Value &custom) const;
  static virtual std::string getCurrent(const boost::filesystem::path &ostree_sysroot);

 private:
  std::string ref_name;
  std::string refhash;
  std::string pull_uri;
};

#endif  // OSTREEINTERFACE_H_
