client = Freshdesk::Client.new

# The Ticket API

# Get one ticket by id.
client.find_ticket(10)

# Get a list of all tickets. The Freshdesk API's default
# concept of "all" is all new, unopened tickets.
# Returns an array of Freshdesk::Ticket objects.
client.all_tickets

# Okay, REALLY give me ALL the tickets. I mean it. Not just new ones.
client.all_tickets(filter_name: 'all_tickets')

# You can use any filter provided by Freshdesk.
# Freshdesk: http://freshdesk.com/api#view_all_ticket

# Get the second page of tickets.
# Freshdesk paginates tickets in batches of 30.
client.all_tickets(filter_name: 'all_tickets', page: 2)

# Get deleted tickets.
client.all_tickets(filter_name: 'deleted')

# Get all tickets submitted by one email address.
client.all_tickets(filter_name: 'all_tickets', email: 'example@gmail.com')
