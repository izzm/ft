require 'plymouth'
require Pathname.pwd.join('lib').join('fft.rb')

describe Array do

  before do
    @tolerance = 1.0e-08
  end

  it 'should calculate forward FFT properly' do
    data = [[2.0, 1.0, 1.0, 2.0],
            [0.0, 0.0, 0.0, 0.0]]
    result = data.fft
    result.first[0].should be_within(@tolerance).of(6.0)
    result.first[1].should be_within(@tolerance).of(1.0)
    result.first[2].should be_within(@tolerance).of(0.0)
    result.first[3].should be_within(@tolerance).of(1.0)
    result.last[0].should be_within(@tolerance).of(0.0)
    result.last[1].should be_within(@tolerance).of(1.0)
    result.last[2].should be_within(@tolerance).of(0.0)
    result.last[3].should be_within(@tolerance).of(-1.0)
  end

  it 'should calculate reverse FFT properly' do
    data = [[6.0, 1.0, 0.0, 1.0],
            [0.0, 1.0, 0.0, -1.0]]
    result = data.rfft
    result.first[0].should be_within(@tolerance).of(2.0)
    result.first[1].should be_within(@tolerance).of(1.0)
    result.first[2].should be_within(@tolerance).of(1.0)
    result.first[3].should be_within(@tolerance).of(2.0)
    result.last[0].should be_within(@tolerance).of(0.0)
    result.last[1].should be_within(@tolerance).of(0.0)
    result.last[2].should be_within(@tolerance).of(0.0)
    result.last[3].should be_within(@tolerance).of(0.0)
  end

end
