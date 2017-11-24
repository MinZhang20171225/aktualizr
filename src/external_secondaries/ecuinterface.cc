#include <boost/program_options.hpp>
#include <iostream>
#include <string>

#include "ecuinterface.h"

namespace po = boost::program_options;
using std::string;

int main(int argc, char **argv) {
  po::options_description desc("Allowed options");

  string command;
  string hardware_identifier;
  string ecu_identifier;
  string firmware_path;

  // clang-format off
  desc.add_options()
    ("loglevel,l", po::value<unsigned int>()->default_value(0),
         "Set log level 0-4 (trace, debug, warning, info, error)")
    ("hardware-identifier", po::value<string>(&hardware_identifier),
         "The hardware identifier of the ECU where the update should be installed (e.g. rh850)")
    ("ecu-identifier", po::value<string>(&ecu_identifier),
         "The unique serial number of the ECU where the update should be installed (e.g. ‘abcdef12345’)")
    ("firmware", po::value<string>(&firmware_path),
         "An absolute path to the firmware image to be installed.")
    ("command", po::value<string>(&command),
         "The command to run api-version | list-ecus | install-software");
  // clang-format on

  po::positional_options_description positional_options;
  positional_options.add("command", 1);

  try {
    po::variables_map vm;
    po::store(po::command_line_parser(argc, argv).options(desc).positional(positional_options).run(), vm);
    po::notify(vm);

    if (vm.count("command")) {
      ECUInterface ecu(vm["loglevel"].as<unsigned int>());
      if (command == "api-version") {
        std::cout << ecu.apiVersion();
        return EXIT_SUCCESS;
      } else if (command == "list-ecus") {
        std::cout << ecu.listEcus();
        return EXIT_SUCCESS;
      } else if (command == "install-software") {
        if (!vm.count("hardware-identifier") || !vm.count("ecu-identifier") || !vm.count("firmware")) {
          std::cerr
              << "install-software command requires --hardware-identifier, --ecu-identifier and --firmware options\n";
          return EXIT_FAILURE;
        }
        if (hardware_identifier != "msp430") {
          std::cerr << "Cannot install firmware unless the hardware identifiers match. Expecting msp430, got "
                    << hardware_identifier << "\n";
          return EXIT_FAILURE;
        }
        return ecu.installSoftware(hardware_identifier, ecu_identifier, firmware_path);
      } else {
        std::cout << "unknown command: " << command[0] << "\n";
        std::cout << desc;
      }

      return EXIT_SUCCESS;
    } else {
      std::cout << "You must provide command: \n";
      std::cout << desc;
      return EXIT_FAILURE;
    }
  } catch (const po::error &o) {
    std::cout << o.what();
    std::cout << desc;
    return EXIT_FAILURE;
  }
}
// vim: set tabstop=2 shiftwidth=2 expandtab: