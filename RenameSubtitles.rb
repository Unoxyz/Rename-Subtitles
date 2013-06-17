=begin
	드라마 자막 파일명 맞추기 v 1.1

	인식 파일 패턴
	"name.s01e02.2HD.ext"
	"name.s1e2.2HD.ext"
	"name.s01.e02.2HD.ext"
	"name.s01_e02.2HD.ext"
	"name.1x02.2HD.ext"
	"name.102.2HD.ext"
=end


movExt = [".mp4", ".mkv", ".avi", ".m4v", ".mov", ".wmv"]
subExt = [".smi", ".srt", ".ass"]

# 확장자를 조건으로 받아서, 파일명+확장자로 분리
def get_filename(*ext, type)
	files = Array.new
	pattern = ( ARGV[0] ? "#{ARGV[0]}/" : '' ) + "*{#{ext.join(",")}}"
	Dir.glob(pattern) do |f|
		filename = Hash.new
		filename[:full] = f
		filename[:base] = File.basename(f, ".*")
		filename[:ext] = File.extname(f)
		filename[:type] = type
		files << filename
	end
	files
end

# 드라마 파일명인지 판단하고, 드라마명, 시즌, 에피소드 추출
def extract_tvshow(file)
	regExs = [
		Regexp.new('[Ss]([0-9]+)[ ._-]*[Ee]([0-9]+)([^\\/]*)$'),
		Regexp.new('[\._ -]()[Ee][Pp]_?([0-9]+)([^\\/]*)$'),
    Regexp.new('[\\/\._ \[\(-]([0-9]+)x([0-9]+)([^\\/]*)$'),
    Regexp.new('[\\/\._ -]([0-9]+)([0-9][0-9])([\._ -][^\\/]*)$')
  ]
	matched = nil

  regExs.each do |reg|
		if file[:base] =~ reg
			file[:show] = $`.tr_s(' ._-', ' ').strip.capitalize
			file[:season] = $1
			file[:episode] = $2
			matched = reg
		else
		end
  end

	file[:type] = :none unless matched
end

movFiles = get_filename(movExt, :mov)
movFiles.each { |e| extract_tvshow(e)}
subFiles = get_filename(subExt, :sub)
subFiles.each { |e| extract_tvshow(e)}

# 파일명 비교 후 자막 파일 변경
total_count = 0
subFiles.each do |sub|
	movFiles.each do |mov|
		if mov[:base] != sub[:base] && mov[:type] == :mov && sub[:type] == :sub && mov[:show] == sub[:show] && mov[:season].to_i == sub[:season].to_i && mov[:episode].to_i == sub[:episode].to_i
			# puts mov[:full] + " == " + sub[:full]
			puts "#{sub[:full]} -> #{mov[:base]}#{sub[:ext]}"
			File.rename(sub[:full], mov[:base] + sub[:ext]) # 실제 파일명 변경
			total_count += 1
		end
	end
end
puts "#{total_count} file(s) renamed."
