#include "ostree_hash.h"

#include <cstring>
#include <iomanip>
#include <sstream>

OSTreeHash OSTreeHash::Parse(const std::string& hash) {
  uint8_t sha256[32];
  std::istringstream refstr(hash);

  if (hash.size() != 64) {
    throw OSTreeCommitParseError("OSTree Hash has invalid length");
  }
  // sha256 is always 256 bits == 32 bytes long
  for (int i = 0; i < 32; i++) {
    char byte_string[3];
    byte_string[2] = 0;
    unsigned long byte_holder;

    refstr.read(byte_string, 2);
    char* next_char;
    byte_holder = strtoul(byte_string, &next_char, 16);
    if (next_char != &byte_string[2]) {
      throw OSTreeCommitParseError("Invalid character in OSTree commit hash");
    }
    sha256[i] = byte_holder & 0xFF;
  }
  return OSTreeHash(sha256);
}

OSTreeHash::OSTreeHash(const uint8_t hash[32]) { std::memcpy(hash_, hash, 32); }

std::string OSTreeHash::string() const {
  std::stringstream str_str;
  str_str.fill('0');

  // sha256 hash is always 256 bits = 32 bytes long
  for (int i = 0; i < 32; i++) str_str << std::setw(2) << std::hex << (unsigned short)hash_[i];
  return str_str.str();
}

bool OSTreeHash::operator<(const OSTreeHash& other) const { return memcmp(hash_, other.hash_, 32) < 0; }

std::ostream& operator<<(std::ostream& os, const OSTreeHash& obj) {
  os << obj.string();
  return os;
}