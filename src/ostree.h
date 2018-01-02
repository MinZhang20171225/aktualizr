#ifndef OSTREE_H_
#define OSTREE_H_

#include <string>

#include <glib/gi18n.h>
#include <ostree-1/ostree.h>
#include <boost/shared_ptr.hpp>

#include "config.h"
#include "types.h"

class Ostree : public OstreeInterface {
 public:
  static boost::shared_ptr<OstreeDeployment> getStagedDeployment(const boost::filesystem::path &path);
  static boost::shared_ptr<OstreeSysroot> LoadSysroot(const boost::filesystem::path &path);
  static bool addRemote(OstreeRepo *repo, const std::string &remote, const std::string &url,
                        const data::PackageManagerCredentials &cred);
  static Json::Value getInstalledPackages(const boost::filesystem::path &file_path);
};

class OstreePackage : public OstreePackageInterface {
 public:
  OstreePackage(const std::string &branch_name_in, const std::string &refhash_in, const std::string &treehub_in);
  data::InstallOutcome install(const data::PackageManagerCredentials &cred, OstreeConfig config) const;
  Json::Value toEcuVersion(const std::string &ecu_serial, const Json::Value &custom) const;
  static std::string getCurrent(const boost::filesystem::path &ostree_sysroot);
};

#endif  // OSTREE_H_
