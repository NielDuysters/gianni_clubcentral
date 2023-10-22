// Global variable accessible over the whole app.
// After the user logs in into the app we save his user_id
// so we can use it when he e.g orders a ticket.
//
// null means no user is logged in.

class UserSession {
    static int? user_id;
}
