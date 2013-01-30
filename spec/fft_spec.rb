require "plymouth"
require Pathname.pwd.join("lib").join("ft.rb")

describe Array do

  before do
    @tolerance = 1.0e-08
  end

  describe "Transform validation" do

    it "should not allow anything different than Complex" do
      data = [2.0, 1.0, 1.0, 2.0]
      lambda { data.fft }.should raise_error
      lambda { data.rfft }.should raise_error
      lambda { data.dft }.should raise_error
      lambda { data.rdft }.should raise_error
    end

    it "should not allow array" do
      data = [Complex(2.0, 0.0), Complex(1.0, 0.0), Complex(1.0, 0.0)]
      lambda { data.fft }.should raise_error
      lambda { data.rfft }.should raise_error
      lambda { data.dft }.should raise_error
      lambda { data.rdft }.should raise_error
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

end
