#define BOOST_TEST_MODULE server

#include <string>
#include <boost/test/unit_test.hpp>

#include "servercon.h"
#include "config.h"

const std::string TSTURL = "https://t.est/url";
const std::string TSTID = "testid";
const std::string TSTSECRET = "testsecret";

const std::string TSTTOKEN = "testtoken345";
const std::string TSTTYPE = "bearer";
const std::string TSTEXPIRE = "1";

/*****************************************************************************/
Config conf;

BOOST_AUTO_TEST_SUITE(servercon)

BOOST_AUTO_TEST_CASE(servercon_constructor) {
  sota_server::ServerCon obj1(conf), obj2(conf);

  if (sizeof(obj1) != sizeof(obj2)) {
    BOOST_FAIL("servercon constructor leads to different sizes.");
  }
}

/*****************************************************************************/

BOOST_AUTO_TEST_CASE(servercon_setmemb)
/* Compare with void free_test_function() */
{
  sota_server::ServerCon obj1(conf);

  obj1.setAuthServer(const_cast<std::string&>(TSTURL));
  obj1.setClientID(const_cast<std::string&>(TSTID));
  obj1.setClientSecret(const_cast<std::string&>(TSTSECRET));

  if (obj1.getOAuthToken() != 0u) {
    BOOST_FAIL(
        "servercon:get_oauthToken returns  success when using invalid data.");
  }
}

BOOST_AUTO_TEST_SUITE_END()

/*****************************************************************************/

BOOST_AUTO_TEST_SUITE(oauthtoken)

BOOST_AUTO_TEST_CASE(oauthtoken_constructor) {
  sota_server::OAuthToken obj1("a", "b", "1"), obj2("a", "b", "1");

  if (sizeof(obj1) != sizeof(obj2)) {
    BOOST_FAIL("oauthToken constructor leads to different sizes.");
  }
}

BOOST_AUTO_TEST_CASE(oauthtoken_setmemb) {
  sota_server::OAuthToken obj1(const_cast<std::string&>(TSTTOKEN),
                               const_cast<std::string&>(TSTTYPE),
                               const_cast<std::string&>(TSTEXPIRE));

  if (obj1.stillValid() == false) {
    BOOST_FAIL(
        "oauthtoken - stillValid() returns false with expire still in time.");
  }

  sleep(2);

  if (obj1.stillValid() == true) {
    BOOST_FAIL(
        "oauthtoken - stillValid() returns true with expire out of time.");
  }

  if (TSTTOKEN.compare(obj1.get()) != 0) {
    BOOST_FAIL("oauthtoken - get() returns wrong token.");
  }
}

BOOST_AUTO_TEST_SUITE_END()
