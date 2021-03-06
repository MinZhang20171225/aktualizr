#ifndef DBUSGATEWAY_H_
#define DBUSGATEWAY_H_

#include <dbus/dbus.h>
#include <boost/atomic.hpp>

#include "commands.h"
#include "config.h"
#include "events.h"
#include "gateway.h"
#include "swlm.h"

class DbusGateway : public Gateway {
 public:
  DbusGateway(const Config &config_in, command::Channel *command_channel_in);
  virtual ~DbusGateway();
  virtual void processEvent(const boost::shared_ptr<event::BaseEvent> &event);
  void fireInstalledSoftwareNeededEvent();
  void fireUpdateAvailableEvent(const data::UpdateAvailable &update_available);
  void fireDownloadCompleteEvent(const data::DownloadComplete &download_complete);
  void run();

 private:
  boost::thread thread;
  boost::atomic<bool> stop;
  data::OperationResult getOperationResult(DBusMessageIter *);
  const Config &config;
  command::Channel *command_channel;
  DBusError err;
  DBusConnection *conn;
  SoftwareLoadingManagerProxy swlm;
};
#endif /* DBUSGATEWAY_H_ */
