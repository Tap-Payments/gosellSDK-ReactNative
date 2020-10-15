//
//  BaseGLView.swift
//  TapGLKit/Core
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import struct   CoreGraphics.CGGeometry.CGRect
import class    GLKit.GLKView.GLKView
import protocol GLKit.GLKView.GLKViewDelegate
import class    OpenGLES.EAGL.EAGLContext
import class    QuartzCore.CADisplayLink.CADisplayLink
import class    UIKit.UIApplication.UIApplication
import class    UIKit.UIColor.UIColor
import class    UIKit.UIView.UIView
import class    UIKit.UIWindow.UIWindow

/// Base abstract class for GL views.
public class BaseGLView: GLKView {

    //MARK: - Public -
    //MARK: Properties
    
    public override var backgroundColor: UIColor? {
        
        didSet {
            
            self.shader?.backgroundColor = self.backgroundColor ?? .clear
            if !self.drawsDynamically {
                
                self.render(nil)
            }
        }
    }
    
    public override var frame: CGRect {
        
        didSet {
            
            self.shader?.renderingRect = self.bounds
            if !self.drawsDynamically {
                
                self.render(nil)
            }
        }
    }
    
    //MARK: Methods
    
    public required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        self.setup()
    }
    
    public override init(frame: CGRect) {
        
        super.init(frame: frame)
        self.setup()
    }
    
    public override init(frame: CGRect, context: EAGLContext) {
        
        super.init(frame: frame, context: context)
        self.setup(context)
    }
    
    public override func layoutSubviews() {
        
        super.layoutSubviews()
        
        self.shader?.renderingRect = self.bounds
        if !self.drawsDynamically {
            
            self.render(nil)
        }
    }
    
    public override func display() {
        
        guard UIApplication.shared.applicationState == .active else { return }
        guard self.window != nil && self.superview != nil && self.shaderCompiled else { return }
        guard !self.isRendering else { return }
        
        self.isRendering = true
        
        super.display()
        
        self.isRendering = false
    }
    
    public override func willMove(toSuperview newSuperview: UIView?) {
        
        super.willMove(toSuperview: newSuperview)
        
        if newSuperview == nil {
            
            self.disableDrawing()
        }
    }
    
    public override func didMoveToSuperview() {
        
        super.didMoveToSuperview()
        
        if self.superview != nil {
            
            self.enableDrawing()
        }
    }
    
    public override func willMove(toWindow newWindow: UIWindow?) {
        
        super.willMove(toWindow: newWindow)
        
        if newWindow == nil {
            
            self.disableDrawing()
        }
    }
    
    public override func didMoveToWindow() {
        
        super.didMoveToWindow()
        
        if self.window != nil {
            
            self.enableDrawing()
        }
    }
    
    //MARK: - Internal -
    //MARK: Properties
    
    internal var shader: BaseShader?
    
    internal var drawsDynamically: Bool {
     
        return true
    }
    
    //MARK: Methods
    
    internal func setup(_ context: EAGLContext? = nil) {
        
        self.enableSetNeedsDisplay = false
        self.isOpaque = false
        
        self.applyContext(context)
        
        self.delegate = self
    }
    
    internal func createShader(with ctx: EAGLContext) {
    
        guard self.shader != nil else {
            
            fatalError("Shader should be created at this stage.")
        }
        
        if self.shader?.backgroundColor != self.backgroundColor {
            
            self.shader?.backgroundColor = self.backgroundColor ?? .clear
        }
        
        self.shader?.renderingRect = self.bounds
        self.shader?.renderingScale = self.layer.contentsScale
        
        self.shaderCompiled = true
    }
    
    @objc internal func render(_ sender: Any?) {
        
        if self.shader?.hasDrawableChanges ?? false {
            
            self.display()
        }
    }
    
    //MARK: - Private -
    //MARK: Properties
    
    private var displayLink: CADisplayLink?
    
    fileprivate var isRendering: Bool = false
    
    private var shaderCompiled: Bool = false {
        
        didSet {
            
            if self.shaderCompiled {
                
                self.enableDrawing()
            }
            else {
                
                self.disableDrawing()
            }
        }
    }
	
	private var runLoopMode: RunLoop.Mode {
		
		#if swift(>=4.2)
		
		return .common
		
		#else
		
		return .commonModes
		
		#endif
	}
	
	private var applicationDidBecomeActiveNotificationName: Notification.Name {
		
		#if swift(>=4.2)
		
		return UIApplication.didBecomeActiveNotification
		
		#else
		
		return .UIApplicationDidBecomeActive
		
		#endif
	}
	
    //MARK: Methods
    
    private func applyContext(_ context: EAGLContext? = nil) {
        
        var aContext: EAGLContext
        
        if let nonnullContext = context {
            
            aContext = nonnullContext
        }
        else {
            
            guard let ctx = EAGLContext(api: .openGLES2) else {
                
                fatalError("Failed to create OpenGL context.")
            }
            
            aContext = ctx
        }
        
        self.context = aContext
        
        self.createShader(with: aContext)
    }
    
    private func enableDrawing() {
        
        self.disableDrawing()
        
        guard self.superview != nil && self.window != nil && self.shaderCompiled else { return }
        
        if self.drawsDynamically {
            
            self.displayLink = CADisplayLink(target: self, selector: #selector(render(_:)))
            self.displayLink?.add(to: .current, forMode: self.runLoopMode)
        }
        else {
            
            self.render(nil)
            
            NotificationCenter.default.addObserver(forName: self.applicationDidBecomeActiveNotificationName, object: nil, queue: .main) { [weak self] (notification) in
                
                self?.render(nil)
            }
        }
    }
    
    private func disableDrawing() {
        
        if self.drawsDynamically {
            
            self.displayLink?.invalidate()
            self.displayLink = nil
        }
        else {
        
            NotificationCenter.default.removeObserver(self)
        }
    }
}

extension BaseGLView: GLKViewDelegate {
    
    public func glkView(_ view: GLKView, drawIn rect: CGRect) {
        
        self.shader?.render()
    }
}
