#include <gtest/gtest.h>

#include "logging.h"
#include "sqlstorage.h"
#include "utils.h"

TEST(sqlstorage, migrate) {
  TemporaryDirectory temp_dir;
  StorageConfig config;
  config.path = temp_dir.Path() / "test.db";
  config.schemas_path = "config/storage";

  SQLStorage storage(config);
  boost::filesystem::remove_all(config.path);

  EXPECT_FALSE(storage.dbCheck());
  EXPECT_TRUE(storage.dbMigrate());
  EXPECT_TRUE(storage.dbCheck());
}

#ifndef __NO_MAIN__
int main(int argc, char **argv) {
  ::testing::InitGoogleTest(&argc, argv);
  logger_init();
  logger_set_threshold(boost::log::trivial::trace);
  return RUN_ALL_TESTS();
}
#endif
