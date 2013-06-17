=begin
# 자막 파일명 일괄 변환 프로그램 #
현재 폴더에서 영상과 파일명이 다른 자막 파일을 일괄적으로 변경한다.
=end

=begin _ToDo_
Dir["*.smi", "*.srt"]
FIle.close 필요.	
=end

# 현재 폴더의 모든 파일을 읽는다.
folder = Dir.entries(".")
ofiles = Array.new
folder.each { |e| ofiles.push(File.basename(e, "r")) }

def parsingFile(file) # 정규표현식을 이용해 파일명을 분해한다.
	movExt = [".mp4", ".mkv", ".avi", ".m4v", ".mov", ".wmv"]
	subExt = [".smi", ".srt", ".ass"]
	ext = /(\....)$/.match(file).to_s.downcase

	tvShow = Array.new
	tvShow[1] = file
	tvShow[2] = /(.+)(?=\.S[0-9][0-9])/.match(file).to_s.tr_s(' ._-', ' ').capitalize	# Show name; 빈칸, ., _, - 등을 빈칸으로 변환
	tvShow[3] = /[0-9][0-9](?=E)/.match(file).to_s						# Season number
	tvShow[4] = /[0-9][0-9](?=\.)/.match(file).to_s					# Episode number

	if movExt.find { |e| e == ext } # 파일의 종류를 판별한다.
		tvShow[0] = "mov"
	elsif subExt.find { |e| e == ext } 
		tvShow[0] = "sub"
	else
		tvShow[0] = "none"
	end
	
	tvShow
end

# 분해한 파일을 배열로 저장한다.
pfiles = Array.new
ofiles.each { |e| pfiles.push parsingFile(e) }

# 위 배열에서 자막 파일을 찾아 영상 파일과 매칭한 후, 자막 파일명을 변경한다.
totalRen = 0
pfiles.each do |i|	
	if i.first == "sub" # 자막 파일이면 
		matchMov = pfiles.find { |j| i[2..4] == j[2..4] && j[0] == "mov" } 
		if matchMov # sub는 있는데 mov가 없으면 통과
			matchMovExt = File.extname(matchMov[1])
			matchMovName = matchMov[1].chomp(matchMovExt)
			matchSubExt = File.extname(i[1])
			matchSubName = i[1].chomp(matchSubExt)
			if matchMovName != matchSubName # 자막과 영상 파일명이 같으면 통과
				print i[1], " -> ", matchMovName, matchSubExt, "\n"
				# File.rename(i[1], matchMovName + matchSubExt)
				totalRen += 1
			end
 		end
	end
end
print totalRen, " file(s) renamed.\n"
