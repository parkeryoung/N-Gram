class NGram
  attr_accessor :ns, :data, :by_input, :all_data
  def initialize(source_data, options={n:1})
    default_values(source_data, options)
    process
  end

  def ngrams_of_inputs(ngram_count = nil)
    re_process(ngram_count)
    by_input
  end

  def ngrams_of_all_data(ngram_count = nil)
    re_process(ngram_count)
    all_data
  end

  private

  def default_values(source_data = self.data, options = {n:1})
    self.ns = [options[:n]].flatten
    self.data = source_data
    self.by_input = []
    self.all_data = template_hash
  end

  def re_process(ngram_count)
    if !ngram_count.nil?
      default_values(self.data, n: ngram_count)
      process
    end
  end

  def process
    data.each do |string|
      bucket = template_hash

      words = string.split(' ')

      (words.size).times do |index|
        self.ns.each do |n|
          # Next if we've ran out of words
          next if (index + n) > words.size
          bucket[n][words[index,n].join(' ')] += 1
          all_data[n][words[index,n].join(' ')] += 1
        end
      end

      by_input << bucket
    end
  end

  def template_hash
    Hash.new do |hash, key|
      hash[key] = Hash.new {|hash, key| hash[key] = 0}
    end
  end

end
