/*-
 * Copyright (c) 2011 Ryota Hayashi
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the distribution.
 *
 * THIS SOFTWARE IS PROVIDED BY THE AUTHOR(S) ``AS IS'' AND ANY EXPRESS OR
 * IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
 * OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
 * IN NO EVENT SHALL THE AUTHOR(S) BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
 * NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
 * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
 * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
 * THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 * $FreeBSD$
 */

#import "MyColorPickerView.h"
#import <sys/time.h>
#import "HRColorMapView.h"
#import "HRBrightnessSlider.h"
#import "HRColorInfoView.h"
#import "HRHSVColorUtil.h"

typedef struct timeval timeval;

@interface MyColorPickerView () {
}

@end

@implementation MyColorPickerView
{
    UIView <HRColorInfoView> *_colorInfoView;
    UIControl <HRColorMapView> *_colorMapView;
    UIControl <HRBrightnessSlider> *_brightnessSlider;

    // 色值
    HRHSVColor _currentHsvColor;

    // 帧速率
    timeval _lastDrawTime;
    timeval _waitTimeDuration;
}

- (id)init {
    return [self initWithFrame:CGRectZero];
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self _init];
        
        CGFloat paddingLeft = 15.0f;
        CGFloat mapHeight = SCREEN_WIDTH-paddingLeft*2;
    
        CGFloat tabbarHeight = [PublicMethod isiPhoneX] ? 90 :75;
        
        WS(weakSelf);
        [self.colorMapView  mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(weakSelf.mas_left).offset(paddingLeft);
            make.right.mas_equalTo(weakSelf.mas_right).offset(-paddingLeft);
            make.height.mas_equalTo(@(mapHeight));
            make.bottom.mas_equalTo(weakSelf.mas_bottom).offset(-paddingLeft -tabbarHeight);
        }];
        
        [self.brightnessSlider mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(weakSelf.mas_left).offset(paddingLeft);
            make.right.mas_equalTo(weakSelf.mas_right).offset(-paddingLeft);
            make.bottom.mas_equalTo(weakSelf.colorMapView.mas_top).offset(-25);
            make.height.equalTo(@11);
        }];

        [self.colorInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(weakSelf.mas_left).offset(paddingLeft);
            make.right.mas_equalTo(weakSelf.mas_right).offset(-paddingLeft);
            make.bottom.mas_equalTo(weakSelf.brightnessSlider.mas_top).offset(-35);
            make.top.mas_equalTo(weakSelf.mas_top).offset(30);
        }];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self _init];
    }
    return self;
}

- (void)_init {
    gettimeofday(&_lastDrawTime, NULL);

    _waitTimeDuration.tv_sec = (__darwin_time_t) 0.0;
    _waitTimeDuration.tv_usec = (__darwin_suseconds_t) (1000000.0 / 15.0);
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
}

- (UIColor *)color {
    return [UIColor colorWithHue:_currentHsvColor.h
                      saturation:_currentHsvColor.s
                      brightness:_currentHsvColor.v
                           alpha:1];
}

- (void)setColor:(UIColor *)color {
    // RGBのデフォルトカラーをHSVに変換
    HSVColorFromUIColor(color, &_currentHsvColor);
    if (_brightnessSlider) self.brightnessSlider.color = self.color;
    if (_colorInfoView) self.colorInfoView.color = self.color;
    if (_colorMapView) {
        self.colorMapView.color = self.color;
        self.colorMapView.brightness = _currentHsvColor.v;
    }
}

- (UIView <HRColorInfoView> *)colorInfoView {
    if (!_colorInfoView) {
        _colorInfoView = [[HRColorInfoView alloc] init];
        _colorInfoView.color = self.color;
        [self addSubview:self.colorInfoView];
    }
    return _colorInfoView;
}

- (void)setColorInfoView:(UIView <HRColorInfoView> *)colorInfoView {
    _colorInfoView = colorInfoView;
    _colorInfoView.color = self.color;
}

- (UIControl <HRBrightnessSlider> *)brightnessSlider {
    if (!_brightnessSlider) {
        _brightnessSlider = [[HRBrightnessSlider alloc] init];
        _brightnessSlider.brightnessLowerLimit = @0;
        _brightnessSlider.color = self.color;
        [_brightnessSlider addTarget:self
                              action:@selector(brightnessChanged:)
                    forControlEvents:UIControlEventValueChanged];
        [self addSubview:_brightnessSlider];
    }
    return _brightnessSlider;
}

- (void)setBrightnessSlider:(UIControl <HRBrightnessSlider> *)brightnessSlider {
    _brightnessSlider = brightnessSlider;
    _brightnessSlider.color = self.color;
    [_brightnessSlider addTarget:self
                          action:@selector(brightnessChanged:)
                forControlEvents:UIControlEventValueChanged];
}

- (UIControl <HRColorMapView> *)colorMapView {
    if (!_colorMapView) {
        HRColorMapView *colorMapView;
        colorMapView = [HRColorMapView colorMapWithFrame:CGRectZero
                                    saturationUpperLimit:0.9];
        colorMapView.tileSize = @1;
        _colorMapView = colorMapView;

        _colorMapView.brightness = _currentHsvColor.v;
        _colorMapView.color = self.color;
        [_colorMapView addTarget:self
                          action:@selector(colorMapColorChanged:)
                forControlEvents:UIControlEventValueChanged];
        _colorMapView.backgroundColor = [UIColor blackColor];
        [self addSubview:_colorMapView];
    }
    return _colorMapView;
}

- (void)setColorMapView:(UIControl <HRColorMapView> *)colorMapView {
    _colorMapView = colorMapView;
    _colorMapView.brightness = _currentHsvColor.v;
    _colorMapView.color = self.color;
    [_colorMapView addTarget:self
                      action:@selector(colorMapColorChanged:)
            forControlEvents:UIControlEventValueChanged];
}

- (void)brightnessChanged:(UIControl <HRBrightnessSlider> *)slider {
    _currentHsvColor.v = slider.brightness.floatValue;
    self.colorMapView.brightness = _currentHsvColor.v;
    self.colorMapView.color = self.color;
    self.colorInfoView.color = self.color;
    [self sendActions];
}

- (void)colorMapColorChanged:(UIControl <HRColorMapView> *)colorMapView {
    HSVColorFromUIColor(colorMapView.color, &_currentHsvColor);
    self.brightnessSlider.color = colorMapView.color;
    self.colorInfoView.color = self.color;
    [self sendActions];
}

- (void)sendActions {
    timeval now, diff;
    gettimeofday(&now, NULL);
            timersub(&now, &_lastDrawTime, &diff);
    if (timercmp(&diff, &_waitTimeDuration, >)) {
        _lastDrawTime = now;
        [self sendActionsForControlEvents:UIControlEventValueChanged];
    }
}


@end

