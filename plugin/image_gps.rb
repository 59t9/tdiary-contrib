# image_gps.rb $Revision: 1.6 $
# 
# ����:
# ������GPS�ˤ����־��󤬴ޤޤ�Ƥ�����ϡ��б������ϿޤؤΥ�󥯤��������롣
#
# �Ȥ���:
# ������Plugin(image.rb)�Ȥ��ʤ�
#
# Copyright (c) 2004,2005 kp <kp@mmho.no-ip.org>
# Distributed under the GPL
#

=begin ChangeLog
2008-01-17 kp
  * �������ѹ�
2006-03-28 kp
  * cooperation with ALPSLAB clip
2006-03-27 kp
  * use exifparser
2005-07-25 kp
  * correct link url when access with mobile.
2005-07-19 kp
  * MapDatum macth to WGS84
2005-05-25 kp
  * correct url link to mapion.
2005-05-24 kp
  * create link to http://walk.eznavi.jp when access with mobile.
2004-11-30 kp
  * first version
=end

require 'wgs2tky'
require 'exifparser'

def image( id, alt = 'image', thumbnail = nil, size = nil, place = 'photo' )
  if @conf.secure then
    image = "#{@image_date}_#{id}.jpg"
    image_t = "#{@image_date}_#{thumbnail}.jpg" if thumbnail
  else
    image = image_list( @image_date )[id.to_i]
    image_t = image_list( @image_date )[thumbnail.to_i] if thumbnail
  end
  if size then
    if size.kind_of?(Array)
      size = " width=\"#{size[0]}\" height=\"#{size[1]}\""
      
    else
      size = " width=\"#{size.to_i}\""
    end
  else
    size = ""
  end
  
  eznavi = 'http://walk.eznavi.jp'
  mapion = 'http://www.mapion.co.jp'

  exif = ExifParser.new("#{@image_dir}/#{image}".untaint) rescue nil
  
  el = nil
  nl = nil
  datum = nil

  if exif
    if @conf['image_gps.add_info']
      alt += ' '+exif['Model'].to_s if exif.tag?('Model')
      alt += ' '+exif['FocalLength'].to_s if exif.tag?('FocalLength')
      alt += ' '+exif['ExposureTime'].to_s if exif.tag?('ExposureTime')
      alt += ' '+exif['FNumber'].to_s if exif.tag?('FNumber')
    end
    begin
      if(exif['GPSLatitudeRef'].value == 'N' && exif['GPSLongitudeRef'].value == 'E' && exif['GPSMapDatum'].value =~ /(WGS-?84|TOKYO)/)
        nl = exif['GPSLatitude'].value if exif.tag?('GPSLatitude')
        el = exif['GPSLongitude'].value if exif.tag?('GPSLongitude')
        datum = exif['GPSMapDatum'].value if exif.tag?('GPSMapDatum')
      end
    rescue
    end
  end

  unless el.nil?
    if @conf.mobile_agent?
      lat = "#{sprintf("%d.%d.%.2f",*nl)}"
      lon = "#{sprintf("%d.%d.%.2f",*el)}"
    else
      Wgs2Tky.conv!(nl,el) if datum =~ /WGS-?84/
      lat ="#{sprintf("%d/%d/%.3f",*nl)}"
      lon ="#{sprintf("%d/%d/%.3f",*el)}"
    end
  end

  if thumbnail
    url = %Q[<a href="#{@image_url}/#{image}"><img class="#{place}" src="#{@image_url}/#{image_t}" alt="#{alt}" title="#{alt}"#{size}></a>]
  elsif el.nil?
    url = %Q[<img class="#{place}" src="#{@image_url}/#{image}" alt="#{alt}" title="#{alt}"#{size}>]
  else
    if @conf.mobile_agent?
      url = %Q[<a href="#{eznavi}/map?datum=#{datum=='TOKYO'?'1':'0'}&amp;unit=0&amp;lat=+#{lat}&amp;lon=+#{lon}">]
    else
      url = %Q[<a href="#{mapion}/c/f?el=#{lon}&amp;nl=#{lat}&amp;uc=1&amp;grp=all">]
    end
    url += %Q[<img class="#{place}" src="#{@image_url}/#{image}" alt="#{alt}" title="#{alt}" #{size}></a>]
  end
  url
end

add_conf_proc ('image_gps','image_gps������','etc') do
  if @mode == 'saveconf' then
    @conf['image_gps.add_info'] = @cgi.params['image_gps.add_info'][0]
  end
  
  <<-HTML
    <p>
    <h3>���ƾ���ɽ��</h3>
    <input type="checkbox" name="image_gps.add_info" value="true" #{if @conf['image_gps.add_info'] then " checked" end}>�����ȥ�˻��ƾ����ɲä���</p>
  HTML

end
