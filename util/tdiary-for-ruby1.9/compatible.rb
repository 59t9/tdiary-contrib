# = for Ruby1.9.0 compatible =
#
# == ������ ==
#
#  * Ruby1.9 �ξ��� --encoding=Binary ���ץ�����ư����뤳��

# --------------------------------------------------------
# ����Ū������
# --------------------------------------------------------

# for Ruby1.9.0

unless "".respond_to?('to_a')
  class String
    def to_a
      [ self ]
    end
  end
end

unless "".respond_to?('each')
  class String
    alias each each_line
  end
end

# Ruby1.9�Ǥ� String �� Enumerable �ǤϤʤ��ʤä�
class String
  def method_missing(name, *args, &block)
    each_line.__send__(name, *args, &block)
  end
end


# for Ruby1.8.X

unless "".respond_to?('force_encoding')
  class String
    def force_encoding(encoding)
      self
    end
  end
end

unless "".respond_to?('bytesize')
  class String
    alias bytesize size
  end
end

unless "".respond_to?('ord')
  class String
    def ord
      self[0]
    end
  end

  class Integer
    def ord
      self
    end
  end
end

# --------------------------------------------------------
# tDiary �Ѥ�����
# --------------------------------------------------------

# Ruby1.9��NKF::nkf��Ƥ֤�ʸ�����encoding���Ѥ�äƤ��ޤ���
# ���Τ��ᡢencoding��Binary�δĶ���ư������
# "character encodings differ" ���顼�Ȥʤ롣
begin
  require 'nkf'
  module NKF
    alias :_nkf :nkf
    def nkf(option, src)
      r = _nkf(option, src)
      r.force_encoding('Binary')
    end
    module_function :nkf, :_nkf
  end
rescue
end

# ���ܸ��ޤ�ĥå��ߤ������� diary.last_modified �� String �ˤʤ� (��������)
# (PStore ��¸���� Time ����, ��¸��� String �Ȥʤ�)
# ����Ū�� String ���ä��� Time ���Ѵ�����
module TDiary
  class WikiDiary
    def last_modified
      if @last_modified.class == String
        @last_modified = Time.at(0)
      end
      @last_modified
    end
  end
end
