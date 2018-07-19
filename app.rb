require_relative 'lib/townhall_scrapper'
require_relative 'lib/townhalls_mailer'
require 'pry'

def main
  puts "We are going to collect emails from 3 french departements: "
  puts '- Ain'
  puts '- Loire'
  puts '- Aisne'
  # collect_emails_json
  puts "Then we are sending emails to each townhall in these departements"
  puts "to let them know about 'The Hacking Project'"
  send_mails
  puts "Finally we are sending sending them tweets, they must know who we are !"
  # follow_tweeter
end

def collect_emails_json
  urls = {
    ain: 'http://annuaire-des-mairies.com/ain.html',
    loire: 'http://annuaire-des-mairies.com/loire.html',
    aisne: 'http://annuaire-des-mairies.com/aisne.html',
  }
  urls.each do |departement, url|
    puts "Generating JSON for #{departement.to_s.capitalize}"
    TownhallScrapper.new(url).list_from_url.write_json_list("db/#{departement}_emails.JSON")
  end
end

def follow_tweeter
  json_file = [
    'db/ain_emails.JSON',
    'db/aisne_emails.JSON',
    'db/loire_emails.JSON'
  ]
  json_file.each do |filename|
    follow = TwitterFollow.new(filename)
    follow.follow
  end
end

def send_mails
  json_file = [
    'db/ain_emails.JSON',
    'db/aisne_emails.JSON',
    'db/loire_emails.JSON'
  ]
  json_file.each do |filename|
    sending = TownhallMailer.new(filename)
    sending.send_email(filename)
  end
end


main
