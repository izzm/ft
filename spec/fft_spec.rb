require 'plymouth'
require Pathname.pwd.join('lib').join('fft.rb')

describe Array do

  before do
    @tolerance = 1.0e-08
  end

  describe 'Fast Fourier Transform' do

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

  describe 'Descreete Fourier Transform' do

    it 'should calculate forward DFT properly' do
      data = [[2.0, 1.0, 1.0, 2.0],
              [0.0, 0.0, 0.0, 0.0]]
      result = data.dft
      result.first[0].should be_within(@tolerance).of(6.0)
      result.first[1].should be_within(@tolerance).of(1.0)
      result.first[2].should be_within(@tolerance).of(0.0)
      result.first[3].should be_within(@tolerance).of(1.0)
      result.last[0].should be_within(@tolerance).of(0.0)
      result.last[1].should be_within(@tolerance).of(1.0)
      result.last[2].should be_within(@tolerance).of(0.0)
      result.last[3].should be_within(@tolerance).of(-1.0)
    end

    it 'should calculate reverse DFT properly' do
      data = [[6.0, 1.0, 0.0, 1.0],
              [0.0, 1.0, 0.0, -1.0]]
      result = data.rdft
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

  describe 'two dimensional Fast Fourier Transform' do

    it 'should calculate FFT2D properly' do
      data = [[[1.0, 1.0, 1.0, 1.0],
               [1.0, 2.0, 2.0, 1.0],
               [1.0, 2.0, 2.0, 1.0],
               [1.0, 1.0, 1.0, 1.0]],
              [[0.0, 0.0, 0.0, 0.0],
               [0.0, 0.0, 0.0, 0.0],
               [0.0, 0.0, 0.0, 0.0],
               [0.0, 0.0, 0.0, 0.0]]]
      result = data.fft2d
      result.first[0][0].should be_within(@tolerance).of(20.0)
      result.first[0][1].should be_within(@tolerance).of(-2.0)
      result.first[0][2].should be_within(@tolerance).of(0.0)
      result.first[0][3].should be_within(@tolerance).of(-2.0)
      result.first[1][0].should be_within(@tolerance).of(-2.0)
      result.first[1][1].should be_within(@tolerance).of(0.0)
      result.first[1][2].should be_within(@tolerance).of(0.0)
      result.first[1][3].should be_within(@tolerance).of(2.0)
      result.first[2][0].should be_within(@tolerance).of(0.0)
      result.first[2][1].should be_within(@tolerance).of(0.0)
      result.first[2][2].should be_within(@tolerance).of(0.0)
      result.first[2][3].should be_within(@tolerance).of(0.0)
      result.first[3][0].should be_within(@tolerance).of(-2.0)
      result.first[3][1].should be_within(@tolerance).of(2.0)
      result.first[3][2].should be_within(@tolerance).of(0.0)
      result.first[3][3].should be_within(@tolerance).of(0.0)
      result.last[0][0].should be_within(@tolerance).of(0.0)
      result.last[0][1].should be_within(@tolerance).of(-2.0)
      result.last[0][2].should be_within(@tolerance).of(0.0)
      result.last[0][3].should be_within(@tolerance).of(2.0)
      result.last[1][0].should be_within(@tolerance).of(-2.0)
      result.last[1][1].should be_within(@tolerance).of(2.0)
      result.last[1][2].should be_within(@tolerance).of(0.0)
      result.last[1][3].should be_within(@tolerance).of(0.0)
      result.last[2][0].should be_within(@tolerance).of(0.0)
      result.last[2][1].should be_within(@tolerance).of(0.0)
      result.last[2][2].should be_within(@tolerance).of(0.0)
      result.last[2][3].should be_within(@tolerance).of(0.0)
      result.last[3][0].should be_within(@tolerance).of(2.0)
      result.last[3][1].should be_within(@tolerance).of(0.0)
      result.last[3][2].should be_within(@tolerance).of(0.0)
      result.last[3][3].should be_within(@tolerance).of(-2.0)
    end

    it 'should calculate RFFT2D properly' do
      data = [[[20.0, -2.0,  0.0, -2.0],
               [-2.0,  0.0,  0.0,  2.0],
               [ 0.0,  0.0,  0.0,  0.0],
               [-2.0,  2.0,  0.0,  0.0]],
              [[ 0.0, -2.0,  0.0,  2.0],
               [-2.0,  2.0,  0.0,  0.0],
               [ 0.0,  0.0,  0.0,  0.0],
               [ 2.0,  0.0,  0.0, -2.0]]]
      result = data.rfft2d
      result.first[0][0].should be_within(@tolerance).of(1.0)
      result.first[0][1].should be_within(@tolerance).of(1.0)
      result.first[0][2].should be_within(@tolerance).of(1.0)
      result.first[0][3].should be_within(@tolerance).of(1.0)
      result.first[1][0].should be_within(@tolerance).of(1.0)
      result.first[1][1].should be_within(@tolerance).of(2.0)
      result.first[1][2].should be_within(@tolerance).of(2.0)
      result.first[1][3].should be_within(@tolerance).of(1.0)
      result.first[2][0].should be_within(@tolerance).of(1.0)
      result.first[2][1].should be_within(@tolerance).of(2.0)
      result.first[2][2].should be_within(@tolerance).of(2.0)
      result.first[2][3].should be_within(@tolerance).of(1.0)
      result.first[3][0].should be_within(@tolerance).of(1.0)
      result.first[3][1].should be_within(@tolerance).of(1.0)
      result.first[3][2].should be_within(@tolerance).of(1.0)
      result.first[3][3].should be_within(@tolerance).of(1.0)
      result.last[0][0].should be_within(@tolerance).of(0.0)
      result.last[0][1].should be_within(@tolerance).of(0.0)
      result.last[0][2].should be_within(@tolerance).of(0.0)
      result.last[0][3].should be_within(@tolerance).of(0.0)
      result.last[1][0].should be_within(@tolerance).of(0.0)
      result.last[1][1].should be_within(@tolerance).of(0.0)
      result.last[1][2].should be_within(@tolerance).of(0.0)
      result.last[1][3].should be_within(@tolerance).of(0.0)
      result.last[2][0].should be_within(@tolerance).of(0.0)
      result.last[2][1].should be_within(@tolerance).of(0.0)
      result.last[2][2].should be_within(@tolerance).of(0.0)
      result.last[2][3].should be_within(@tolerance).of(0.0)
      result.last[3][0].should be_within(@tolerance).of(0.0)
      result.last[3][1].should be_within(@tolerance).of(0.0)
      result.last[3][2].should be_within(@tolerance).of(0.0)
      result.last[3][3].should be_within(@tolerance).of(0.0)
    end

  end

  describe 'two dimensional Descreete Fourier Transform' do

    it 'should calculate DFT2D properly' do
      data = [[[1.0, 1.0, 1.0, 1.0],
               [1.0, 2.0, 2.0, 1.0],
               [1.0, 2.0, 2.0, 1.0],
               [1.0, 1.0, 1.0, 1.0]],
              [[0.0, 0.0, 0.0, 0.0],
               [0.0, 0.0, 0.0, 0.0],
               [0.0, 0.0, 0.0, 0.0],
               [0.0, 0.0, 0.0, 0.0]]]
      result = data.dft2d
      result.first[0][0].should be_within(@tolerance).of(20.0)
      result.first[0][1].should be_within(@tolerance).of(-2.0)
      result.first[0][2].should be_within(@tolerance).of(0.0)
      result.first[0][3].should be_within(@tolerance).of(-2.0)
      result.first[1][0].should be_within(@tolerance).of(-2.0)
      result.first[1][1].should be_within(@tolerance).of(0.0)
      result.first[1][2].should be_within(@tolerance).of(0.0)
      result.first[1][3].should be_within(@tolerance).of(2.0)
      result.first[2][0].should be_within(@tolerance).of(0.0)
      result.first[2][1].should be_within(@tolerance).of(0.0)
      result.first[2][2].should be_within(@tolerance).of(0.0)
      result.first[2][3].should be_within(@tolerance).of(0.0)
      result.first[3][0].should be_within(@tolerance).of(-2.0)
      result.first[3][1].should be_within(@tolerance).of(2.0)
      result.first[3][2].should be_within(@tolerance).of(0.0)
      result.first[3][3].should be_within(@tolerance).of(0.0)
      result.last[0][0].should be_within(@tolerance).of(0.0)
      result.last[0][1].should be_within(@tolerance).of(-2.0)
      result.last[0][2].should be_within(@tolerance).of(0.0)
      result.last[0][3].should be_within(@tolerance).of(2.0)
      result.last[1][0].should be_within(@tolerance).of(-2.0)
      result.last[1][1].should be_within(@tolerance).of(2.0)
      result.last[1][2].should be_within(@tolerance).of(0.0)
      result.last[1][3].should be_within(@tolerance).of(0.0)
      result.last[2][0].should be_within(@tolerance).of(0.0)
      result.last[2][1].should be_within(@tolerance).of(0.0)
      result.last[2][2].should be_within(@tolerance).of(0.0)
      result.last[2][3].should be_within(@tolerance).of(0.0)
      result.last[3][0].should be_within(@tolerance).of(2.0)
      result.last[3][1].should be_within(@tolerance).of(0.0)
      result.last[3][2].should be_within(@tolerance).of(0.0)
      result.last[3][3].should be_within(@tolerance).of(-2.0)
    end

    it 'should calculate RDFT2D properly' do
      data = [[[20.0, -2.0,  0.0, -2.0],
               [-2.0,  0.0,  0.0,  2.0],
               [ 0.0,  0.0,  0.0,  0.0],
               [-2.0,  2.0,  0.0,  0.0]],
              [[ 0.0, -2.0,  0.0,  2.0],
               [-2.0,  2.0,  0.0,  0.0],
               [ 0.0,  0.0,  0.0,  0.0],
               [ 2.0,  0.0,  0.0, -2.0]]]
      result = data.rdft2d
      result.first[0][0].should be_within(@tolerance).of(1.0)
      result.first[0][1].should be_within(@tolerance).of(1.0)
      result.first[0][2].should be_within(@tolerance).of(1.0)
      result.first[0][3].should be_within(@tolerance).of(1.0)
      result.first[1][0].should be_within(@tolerance).of(1.0)
      result.first[1][1].should be_within(@tolerance).of(2.0)
      result.first[1][2].should be_within(@tolerance).of(2.0)
      result.first[1][3].should be_within(@tolerance).of(1.0)
      result.first[2][0].should be_within(@tolerance).of(1.0)
      result.first[2][1].should be_within(@tolerance).of(2.0)
      result.first[2][2].should be_within(@tolerance).of(2.0)
      result.first[2][3].should be_within(@tolerance).of(1.0)
      result.first[3][0].should be_within(@tolerance).of(1.0)
      result.first[3][1].should be_within(@tolerance).of(1.0)
      result.first[3][2].should be_within(@tolerance).of(1.0)
      result.first[3][3].should be_within(@tolerance).of(1.0)
      result.last[0][0].should be_within(@tolerance).of(0.0)
      result.last[0][1].should be_within(@tolerance).of(0.0)
      result.last[0][2].should be_within(@tolerance).of(0.0)
      result.last[0][3].should be_within(@tolerance).of(0.0)
      result.last[1][0].should be_within(@tolerance).of(0.0)
      result.last[1][1].should be_within(@tolerance).of(0.0)
      result.last[1][2].should be_within(@tolerance).of(0.0)
      result.last[1][3].should be_within(@tolerance).of(0.0)
      result.last[2][0].should be_within(@tolerance).of(0.0)
      result.last[2][1].should be_within(@tolerance).of(0.0)
      result.last[2][2].should be_within(@tolerance).of(0.0)
      result.last[2][3].should be_within(@tolerance).of(0.0)
      result.last[3][0].should be_within(@tolerance).of(0.0)
      result.last[3][1].should be_within(@tolerance).of(0.0)
      result.last[3][2].should be_within(@tolerance).of(0.0)
      result.last[3][3].should be_within(@tolerance).of(0.0)
    end

  end

end
