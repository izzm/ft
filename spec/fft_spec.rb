require "plymouth"
require Pathname.pwd.join("lib").join("ft.rb")

describe Array do

  before do
    @tolerance = 1.0e-08
  end

  describe "Transform validation" do

    it "should not allow anything different than Complex" do
      data = [2.0, 1.0, 1.0, 2.0]
      lambda { data.fft }.should raise_error(TypeError)
      lambda { data.rfft }.should raise_error(TypeError)
      lambda { data.dft }.should raise_error(TypeError)
      lambda { data.rdft }.should raise_error(TypeError)
    end

    it "should not allow array" do
      data = [Complex(2.0, 0.0), Complex(1.0, 0.0), Complex(1.0, 0.0)]
      lambda { data.fft }.should raise_error(ArgumentError)
      lambda { data.rfft }.should raise_error(ArgumentError)
      lambda { data.dft }.should raise_error(ArgumentError)
      lambda { data.rdft }.should raise_error(ArgumentError)
    end

  end

  describe "Fast Fourier Transform" do

    it "should calculate forward FFT properly" do
      data = [Complex(2.0, 0.0), Complex(1.0, 0.0), Complex(1.0, 0.0), Complex(2.0, 0.0)]
      result = data.fft
      result[0].real.should be_within(@tolerance).of(6.0)
      result[1].real.should be_within(@tolerance).of(1.0)
      result[2].real.should be_within(@tolerance).of(0.0)
      result[3].real.should be_within(@tolerance).of(1.0)
      result[0].imag.should be_within(@tolerance).of(0.0)
      result[1].imag.should be_within(@tolerance).of(1.0)
      result[2].imag.should be_within(@tolerance).of(0.0)
      result[3].imag.should be_within(@tolerance).of(-1.0)
    end

    it "should calculate reverse FFT properly" do
      data = [Complex(6.0, 0.0), Complex(1.0, 1.0), Complex(0.0, 0.0), Complex(1.0, -1.0)]
      result = data.rfft
      result[0].real.should be_within(@tolerance).of(2.0)
      result[1].real.should be_within(@tolerance).of(1.0)
      result[2].real.should be_within(@tolerance).of(1.0)
      result[3].real.should be_within(@tolerance).of(2.0)
      result[0].imag.should be_within(@tolerance).of(0.0)
      result[1].imag.should be_within(@tolerance).of(0.0)
      result[2].imag.should be_within(@tolerance).of(0.0)
      result[3].imag.should be_within(@tolerance).of(0.0)
    end

  end

  describe "Descreete Fourier Transform" do

    it "should calculate forward FFT properly" do
      data = [Complex(2.0, 0.0), Complex(1.0, 0.0), Complex(1.0, 0.0), Complex(2.0, 0.0)]
      result = data.dft
      result[0].real.should be_within(@tolerance).of(6.0)
      result[1].real.should be_within(@tolerance).of(1.0)
      result[2].real.should be_within(@tolerance).of(0.0)
      result[3].real.should be_within(@tolerance).of(1.0)
      result[0].imag.should be_within(@tolerance).of(0.0)
      result[1].imag.should be_within(@tolerance).of(1.0)
      result[2].imag.should be_within(@tolerance).of(0.0)
      result[3].imag.should be_within(@tolerance).of(-1.0)
    end

    it "should calculate reverse FFT properly" do
      data = [Complex(6.0, 0.0), Complex(1.0, 1.0), Complex(0.0, 0.0), Complex(1.0, -1.0)]
      result = data.rdft
      result[0].real.should be_within(@tolerance).of(2.0)
      result[1].real.should be_within(@tolerance).of(1.0)
      result[2].real.should be_within(@tolerance).of(1.0)
      result[3].real.should be_within(@tolerance).of(2.0)
      result[0].imag.should be_within(@tolerance).of(0.0)
      result[1].imag.should be_within(@tolerance).of(0.0)
      result[2].imag.should be_within(@tolerance).of(0.0)
      result[3].imag.should be_within(@tolerance).of(0.0)
    end

  end

  describe "two dimensional Fast Fourier Transform" do

    it "should calculate FFT2D properly" do
      data = [[Complex(1.0, 0.0), Complex(1.0, 0.0), Complex(1.0, 0.0), Complex(1.0, 0.0)],
              [Complex(1.0, 0.0), Complex(2.0, 0.0), Complex(2.0, 0.0), Complex(1.0, 0.0)],
              [Complex(1.0, 0.0), Complex(2.0, 0.0), Complex(2.0, 0.0), Complex(1.0, 0.0)],
              [Complex(1.0, 0.0), Complex(1.0, 0.0), Complex(1.0, 0.0), Complex(1.0, 0.0)]]
      result = data.fft2d
      result[0][0].real.should be_within(@tolerance).of(20.0)
      result[0][1].real.should be_within(@tolerance).of(-2.0)
      result[0][2].real.should be_within(@tolerance).of(0.0)
      result[0][3].real.should be_within(@tolerance).of(-2.0)
      result[1][0].real.should be_within(@tolerance).of(-2.0)
      result[1][1].real.should be_within(@tolerance).of(0.0)
      result[1][2].real.should be_within(@tolerance).of(0.0)
      result[1][3].real.should be_within(@tolerance).of(2.0)
      result[2][0].real.should be_within(@tolerance).of(0.0)
      result[2][1].real.should be_within(@tolerance).of(0.0)
      result[2][2].real.should be_within(@tolerance).of(0.0)
      result[2][3].real.should be_within(@tolerance).of(0.0)
      result[3][0].real.should be_within(@tolerance).of(-2.0)
      result[3][1].real.should be_within(@tolerance).of(2.0)
      result[3][2].real.should be_within(@tolerance).of(0.0)
      result[3][3].real.should be_within(@tolerance).of(0.0)
      result[0][0].imag.should be_within(@tolerance).of(0.0)
      result[0][1].imag.should be_within(@tolerance).of(-2.0)
      result[0][2].imag.should be_within(@tolerance).of(0.0)
      result[0][3].imag.should be_within(@tolerance).of(2.0)
      result[1][0].imag.should be_within(@tolerance).of(-2.0)
      result[1][1].imag.should be_within(@tolerance).of(2.0)
      result[1][2].imag.should be_within(@tolerance).of(0.0)
      result[1][3].imag.should be_within(@tolerance).of(0.0)
      result[2][0].imag.should be_within(@tolerance).of(0.0)
      result[2][1].imag.should be_within(@tolerance).of(0.0)
      result[2][2].imag.should be_within(@tolerance).of(0.0)
      result[2][3].imag.should be_within(@tolerance).of(0.0)
      result[3][0].imag.should be_within(@tolerance).of(2.0)
      result[3][1].imag.should be_within(@tolerance).of(0.0)
      result[3][2].imag.should be_within(@tolerance).of(0.0)
      result[3][3].imag.should be_within(@tolerance).of(-2.0)
    end

    it "should calculate RFFT2D properly" do
      data = [[Complex(20.0,  0.0), Complex(-2.0, -2.0), Complex( 0.0,  0.0), Complex(-2.0,  2.0)],
              [Complex(-2.0, -2.0), Complex( 0.0,  2.0), Complex( 0.0,  0.0), Complex( 2.0,  0.0)],
              [Complex( 0.0,  0.0), Complex( 0.0,  0.0), Complex( 0.0,  0.0), Complex( 0.0,  0.0)],
              [Complex(-2.0,  2.0), Complex( 2.0,  0.0), Complex( 0.0,  0.0), Complex( 0.0, -2.0)]]
      result = data.rfft2d
      result[0][0].real.should be_within(@tolerance).of(1.0)
      result[0][1].real.should be_within(@tolerance).of(1.0)
      result[0][2].real.should be_within(@tolerance).of(1.0)
      result[0][3].real.should be_within(@tolerance).of(1.0)
      result[1][0].real.should be_within(@tolerance).of(1.0)
      result[1][1].real.should be_within(@tolerance).of(2.0)
      result[1][2].real.should be_within(@tolerance).of(2.0)
      result[1][3].real.should be_within(@tolerance).of(1.0)
      result[2][0].real.should be_within(@tolerance).of(1.0)
      result[2][1].real.should be_within(@tolerance).of(2.0)
      result[2][2].real.should be_within(@tolerance).of(2.0)
      result[2][3].real.should be_within(@tolerance).of(1.0)
      result[3][0].real.should be_within(@tolerance).of(1.0)
      result[3][1].real.should be_within(@tolerance).of(1.0)
      result[3][2].real.should be_within(@tolerance).of(1.0)
      result[3][3].real.should be_within(@tolerance).of(1.0)
      result[0][0].imag.should be_within(@tolerance).of(0.0)
      result[0][1].imag.should be_within(@tolerance).of(0.0)
      result[0][2].imag.should be_within(@tolerance).of(0.0)
      result[0][3].imag.should be_within(@tolerance).of(0.0)
      result[1][0].imag.should be_within(@tolerance).of(0.0)
      result[1][1].imag.should be_within(@tolerance).of(0.0)
      result[1][2].imag.should be_within(@tolerance).of(0.0)
      result[1][3].imag.should be_within(@tolerance).of(0.0)
      result[2][0].imag.should be_within(@tolerance).of(0.0)
      result[2][1].imag.should be_within(@tolerance).of(0.0)
      result[2][2].imag.should be_within(@tolerance).of(0.0)
      result[2][3].imag.should be_within(@tolerance).of(0.0)
      result[3][0].imag.should be_within(@tolerance).of(0.0)
      result[3][1].imag.should be_within(@tolerance).of(0.0)
      result[3][2].imag.should be_within(@tolerance).of(0.0)
      result[3][3].imag.should be_within(@tolerance).of(0.0)
    end

  end

  describe "two dimensional Descreete Fourier Transform" do

    it "should calculate DFT2D properly" do
      data = [[Complex(1.0, 0.0), Complex(1.0, 0.0), Complex(1.0, 0.0), Complex(1.0, 0.0)],
              [Complex(1.0, 0.0), Complex(2.0, 0.0), Complex(2.0, 0.0), Complex(1.0, 0.0)],
              [Complex(1.0, 0.0), Complex(2.0, 0.0), Complex(2.0, 0.0), Complex(1.0, 0.0)],
              [Complex(1.0, 0.0), Complex(1.0, 0.0), Complex(1.0, 0.0), Complex(1.0, 0.0)]]
      result = data.fft2d
      result[0][0].real.should be_within(@tolerance).of(20.0)
      result[0][1].real.should be_within(@tolerance).of(-2.0)
      result[0][2].real.should be_within(@tolerance).of(0.0)
      result[0][3].real.should be_within(@tolerance).of(-2.0)
      result[1][0].real.should be_within(@tolerance).of(-2.0)
      result[1][1].real.should be_within(@tolerance).of(0.0)
      result[1][2].real.should be_within(@tolerance).of(0.0)
      result[1][3].real.should be_within(@tolerance).of(2.0)
      result[2][0].real.should be_within(@tolerance).of(0.0)
      result[2][1].real.should be_within(@tolerance).of(0.0)
      result[2][2].real.should be_within(@tolerance).of(0.0)
      result[2][3].real.should be_within(@tolerance).of(0.0)
      result[3][0].real.should be_within(@tolerance).of(-2.0)
      result[3][1].real.should be_within(@tolerance).of(2.0)
      result[3][2].real.should be_within(@tolerance).of(0.0)
      result[3][3].real.should be_within(@tolerance).of(0.0)
      result[0][0].imag.should be_within(@tolerance).of(0.0)
      result[0][1].imag.should be_within(@tolerance).of(-2.0)
      result[0][2].imag.should be_within(@tolerance).of(0.0)
      result[0][3].imag.should be_within(@tolerance).of(2.0)
      result[1][0].imag.should be_within(@tolerance).of(-2.0)
      result[1][1].imag.should be_within(@tolerance).of(2.0)
      result[1][2].imag.should be_within(@tolerance).of(0.0)
      result[1][3].imag.should be_within(@tolerance).of(0.0)
      result[2][0].imag.should be_within(@tolerance).of(0.0)
      result[2][1].imag.should be_within(@tolerance).of(0.0)
      result[2][2].imag.should be_within(@tolerance).of(0.0)
      result[2][3].imag.should be_within(@tolerance).of(0.0)
      result[3][0].imag.should be_within(@tolerance).of(2.0)
      result[3][1].imag.should be_within(@tolerance).of(0.0)
      result[3][2].imag.should be_within(@tolerance).of(0.0)
      result[3][3].imag.should be_within(@tolerance).of(-2.0)
    end

    it "should calculate RDFT2D properly" do
      data = [[Complex(20.0,  0.0), Complex(-2.0, -2.0), Complex( 0.0,  0.0), Complex(-2.0,  2.0)],
              [Complex(-2.0, -2.0), Complex( 0.0,  2.0), Complex( 0.0,  0.0), Complex( 2.0,  0.0)],
              [Complex( 0.0,  0.0), Complex( 0.0,  0.0), Complex( 0.0,  0.0), Complex( 0.0,  0.0)],
              [Complex(-2.0,  2.0), Complex( 2.0,  0.0), Complex( 0.0,  0.0), Complex( 0.0, -2.0)]]
      result = data.rdft2d
      result[0][0].real.should be_within(@tolerance).of(1.0)
      result[0][1].real.should be_within(@tolerance).of(1.0)
      result[0][2].real.should be_within(@tolerance).of(1.0)
      result[0][3].real.should be_within(@tolerance).of(1.0)
      result[1][0].real.should be_within(@tolerance).of(1.0)
      result[1][1].real.should be_within(@tolerance).of(2.0)
      result[1][2].real.should be_within(@tolerance).of(2.0)
      result[1][3].real.should be_within(@tolerance).of(1.0)
      result[2][0].real.should be_within(@tolerance).of(1.0)
      result[2][1].real.should be_within(@tolerance).of(2.0)
      result[2][2].real.should be_within(@tolerance).of(2.0)
      result[2][3].real.should be_within(@tolerance).of(1.0)
      result[3][0].real.should be_within(@tolerance).of(1.0)
      result[3][1].real.should be_within(@tolerance).of(1.0)
      result[3][2].real.should be_within(@tolerance).of(1.0)
      result[3][3].real.should be_within(@tolerance).of(1.0)
      result[0][0].imag.should be_within(@tolerance).of(0.0)
      result[0][1].imag.should be_within(@tolerance).of(0.0)
      result[0][2].imag.should be_within(@tolerance).of(0.0)
      result[0][3].imag.should be_within(@tolerance).of(0.0)
      result[1][0].imag.should be_within(@tolerance).of(0.0)
      result[1][1].imag.should be_within(@tolerance).of(0.0)
      result[1][2].imag.should be_within(@tolerance).of(0.0)
      result[1][3].imag.should be_within(@tolerance).of(0.0)
      result[2][0].imag.should be_within(@tolerance).of(0.0)
      result[2][1].imag.should be_within(@tolerance).of(0.0)
      result[2][2].imag.should be_within(@tolerance).of(0.0)
      result[2][3].imag.should be_within(@tolerance).of(0.0)
      result[3][0].imag.should be_within(@tolerance).of(0.0)
      result[3][1].imag.should be_within(@tolerance).of(0.0)
      result[3][2].imag.should be_within(@tolerance).of(0.0)
      result[3][3].imag.should be_within(@tolerance).of(0.0)
    end

  end

end
