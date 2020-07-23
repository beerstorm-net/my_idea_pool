// used for AuthBloc
enum ORIGIN {
  LOGIN,
  LOGOUT,
  SIGNUP,
  REFRESH_TOKEN,
  CURRENT_USER,
  RELOAD,
}

// used for SharedPreferences
enum PREFKEY { SETTINGS_DEBUG, APP_USER }
Map<PREFKEY, String> PREFKEYS = {
  PREFKEY.SETTINGS_DEBUG: "APP_SETTINGS_DEBUG",
  PREFKEY.APP_USER: "APP_USER"
};

// TODO: revisit the structure, e.g. import from json
String API_BASE = "https://small-project-api.herokuapp.com";
String API_HEADER_TOKEN = "X-Access-Token";
String API_SIGNUP = "/users"; // POST
String API_LOGIN = "/access-tokens"; // POST
String API_LOGOUT = "/access-tokens"; // DELETE
String API_REFRESH_TOKEN = "/access-tokens/refresh"; // POST
String API_CURRENT_USER = "/me"; // GET
String API_IDEA_ADD = "/ideas"; // POST
String API_IDEA_DELETE = "/ideas/:id"; // DELETE
String API_IDEA_UPDATE = "/ideas/:id"; // PUT
String API_IDEAS = "/ideas"; // GET
