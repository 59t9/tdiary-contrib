# bigpresen.rb $Revision: 1.03 $
#
# bigpresen : ����å��ǿʹԤ���ֹⶶ�᥽�åɡ�������ʸ���ץ쥼��ơ�����������
#
#  �ѥ�᥿ :
#  str : ��ʸ��"|"�ϥ��饤�ɤζ��ڤꡢ"/"�ϥ��饤����β��ԤȤʤ롣
#   "|"��"|"��ɽ��������ˤϡ�����"\"��Ĥ��ƥ��������ס�
#  width : ���饤�ɤ������ԥ�����ǻ��ꡣ(�ǥե���� : 480)
#  height : ���饤�ɤι⤵���ԥ�����ǻ��ꡣ(�ǥե���� : 320)
#
# ������ʸ�ˡ�<%= bigpresen 'str','width','height' %> �η����ǵ��Ҥ��ޤ���
# ʸ���Υ������ϡ�ɽ���ƥ����Ȥȥ��饤�ɤΥ������˹礦�褦��ưŪ��Ĵ������ޤ���
# JavaScript��DHTML���Ѥ���ư�����Τǡ������Ķ��ˤ�äƤ�ɽ������ʤ����Ȥ⤢��ޤ���
#
# Copyright (c) 2006 Maripo Goda 
# mailto:madin@madin.jp
# Document URL http://www.madin.jp/works/plugin.html
# You can redistribute it and/or modify it under GPL2.

@bigPresenID = 0;

def bigpresen (str='', width='480',height='320')
	scriptID = 'bp' + @bigPresenID.to_s
	@bigPresenID += 1;

	presen_ary = str.gsub("\\/",'&frasl;').gsub("\\|","&\#65073").split(/\|/);
	presen_ary.collect!{|s|
		s = '"' + s.gsub('/','<br>') + '"'
	}
	presen_str = presen_ary.join(',')

return <<HTML
<script type="text/javascript">
<!--
t#{scriptID} = 0;
w#{scriptID}=#{width};
h#{scriptID}="#{height}";
msg#{scriptID} = new Array(#{presen_str});
function #{scriptID} () {
	if (t#{scriptID} < msg#{scriptID}.length) {
		msgArr = msg#{scriptID}[t#{scriptID}].split('<br>');
		maxPx = h#{scriptID} * 0.8;
		for (t = 0; t < msgArr.length; t ++) {
			maxPx = Math.min(maxPx, w#{scriptID} * 2 * 0.9 / countLength(msgArr[t]));
		}
		maxPx = Math.min(maxPx, Math.floor(h#{scriptID} * 0.8 / msgArr.length));
	        with (document.getElementById("#{scriptID}")) {	
			innerHTML = msg#{scriptID}[t#{scriptID}];
			style.fontSize = maxPx+"px";
			style.top = ((h#{scriptID}-(maxPx * msgArr.length)) / 2) + "px";
		}
		t#{scriptID} ++;
	}
	else {
		t#{scriptID} = 0;
		with (document.getElementById("#{scriptID}")) {
			innerHTML = "��REPLAY��";
			style.fontSize = '100%';
			style.top = '50%';
		}
	}
}

function countLength (str) 
	{
	len = 0;
	for (i = 0; i < str.length; i++) {
		len ++;
		if (escape(str.charAt(i)).length > 3) {
			len ++
		}
	}
	return Math.max(len, 1);
}
-->
</script>

<noscript><p>JavaScript Required.</p></noscript>
<div class="bigpresen" style="text-align:center; position:relative; width:#{width}px; height:#{height}px; background:#fff;border:ridge 4px #ccc;" onclick="#{scriptID}()">

<span id="#{scriptID}" style="width:100%; position:absolute; top:50%; left:0; line-height:100%; color:black; font-family:'�ͣ� �Х����å�', sans-serif;">��START��</span>

</div>

HTML
end
