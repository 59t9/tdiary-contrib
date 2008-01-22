$KCODE = 'e'
require 'rubygems'
gem 'rspec'
require 'spec'
require 'tmpdir'
require 'fileutils'
begin
	$:.unshift(File.join(File.dirname(__FILE__), "..", "plugin"))
  require 'my_hotentry'
rescue
end

describe "MyHotEntry" do
	before do
		# @cache_path �ϡ֥ե�����̾-�ץ����ֹ��
		@cache_path = File.join(Dir.tmpdir, "#{__FILE__}-#{$$}")
		Dir.mkdir(@cache_path)
		@dbfile = "#{@cache_path}/my_hotentry.dat"
	end

	after do
		FileUtils.rmtree(@cache_path)
	end

	it "update" do
		# �͵��������������������
		base_url = 'http://d.hatena.ne.jp/'
		hotentry = MyHotEntry.new(@dbfile)
		hotentry.update(base_url)
		# ����å���ե����뤬��������Ƥ��뤳��
		File.file?(@dbfile).should be_true
		# �͵��������������Ǥ��Ƥ��뤳��
		entries = hotentry.entries
		entries.size.should > 0
		entries.each do |entry|
			entry[:url].should be_include(base_url)
			entry[:title].size.should > 0
		end
	end

	# ���٤�������Ƥ⥭��å��奵�������礭���ʤ�ʤ�����
	it "double update" do
		base_url = 'http://d.hatena.ne.jp/'
		hotentry = MyHotEntry.new(@dbfile)
		sleep 0.5
		hotentry.update(base_url)
		hotentry.entries.size.should > 0
		size = hotentry.entries.size
		sleep 0.5
		hotentry.update(base_url)
		hotentry.entries.size.should == size
	end

	# ������̤����ξ��ϥ���å���򥯥ꥢ���ʤ�
	it "update noentry" do
		exist_url = 'http://d.hatena.ne.jp/'
		empty_url = 'http://empty-url-123456'
		hotentry = MyHotEntry.new(@dbfile)

		sleep 0.5
		hotentry.update(empty_url)
		hotentry.entries.size.should == 0

		sleep 0.5
		hotentry.update(exist_url)
		hotentry.entries.size.should > 0
		exist_size = hotentry.entries.size

		sleep 0.5
		hotentry.update(empty_url)
		hotentry.entries.size.should == exist_size
	end
end
