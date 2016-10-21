require 'open-uri'
download = open('http://physis.arch.tamu.edu/files/http_access_log')
IO.copy_stream(download, 'log')

Dir.mkdir('monthly logs') unless File.exists?('monthly logs')
#File.open('monthly logs/' + 'October 1994.txt', 'w+')

#string parse and string format strptime(string, pattern) strftime(pattern)




errors  = []
stats = {}


log = File.open('http_access_log.txt')
#log = File.open('smalllog.txt')

log.each_line do |line|
    puts line 
    match_arr = /.* \[(.*) .*\] "([A-Z]{3,5}) (.*) .*" ([2-5][0-9]{2}) .+/.match(line)
    
    # test that we matched the line 
    if !match_arr then 
        errors.push(line)
        next 
    end 
        
    # stash the matches into local variables 
    request_date = match_arr[1]
    http_method = match_arr[2]
    request_path = match_arr[3]
    status_code = match_arr[4]
    
    # record the count for request by status code 
    if stats[status_code] then 
        stats[status_code] += 1 
    else
        stats[status_code] = 1
    end     
    

    
end
    
puts stats
puts errors


grand_total = 0    
all_400s = 0
all_300s = 0
stats.each do |k,v|
    if k[0] == "3" then all_300s += v end 
    if k[0] == "4" then all_400s += v end 
    grand_total += v
end

puts all_400s        

# Olivia helped with my floating issue
puts "The total number of requests is #{grand_total}"
puts "The percentage of errors is: #{(all_400s.to_f / grand_total.to_f * 100).truncate}%"
        
date_array = []
for line in log
  raw_date = line.scan(/\d{1,2}\/\S\S\S\/\d{4}/)
  date_array.push(raw_date)
end




    


date_str_array = []
for date_line in date_array
  for date in date_line
    date_str_array.push(date[3..11])
  end
end

date_hash = Hash.new(0)

for date_str in date_str_array
  date_hash.store(date_str, date_hash[date_str]+1)
end

for date_key,date_value in date_hash
  puts "On (#{date_key}) there were #{date_value} requests"
end
