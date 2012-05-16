require 'plymouth'
require Pathname.pwd.join('lib').join('ft.rb')

describe Array do

  before do
    @tolerance = 1.0e-08
  end

  describe 'data processing tools' do

    it 'should switch quartes properly' do
      data = [[2.0, 1.0, 1.0, 2.0],
              [1.0, 1.0, 1.0, 1.0],
              [1.0, 1.0, 1.0, 1.0],
              [2.0, 1.0, 1.0, 2.0]]
      data.switch_quarters.should eq([[1.0, 1.0, 1.0, 1.0],
                                      [1.0, 2.0, 2.0, 1.0],
                                      [1.0, 2.0, 2.0, 1.0],
                                      [1.0, 1.0, 1.0, 1.0]])
    end

    it 'should calculate magnitude properly' do
      data = [[3.0, 1.0, 1.0, 2.0],
              [4.0, 2.0, 1.0, 0.0]]
      result = data.magnitude
      result[0].should be_within(@tolerance).of(5.0)
      result[1].should be_within(@tolerance).of(Math.sqrt(5))
      result[2].should be_within(@tolerance).of(Math.sqrt(2))
      result[3].should be_within(@tolerance).of(2.0)
    end

    it 'should calculate phase properly' do
      data = [[0.0, 1.0, 1.0,  1.0],
              [1.0, 1.0, 0.0, -1.0]]
      result = data.phase
      result.size.times do |i|
        result[i].should be_within(@tolerance).of(i.to_f * Math::PI / 4.0)
      end
    end

  end

end
