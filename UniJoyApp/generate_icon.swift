#!/usr/bin/env swift
import AppKit

// Generate warm-themed UniJoy app icon
let sizes: [Int] = [16, 32, 64, 128, 256, 512, 1024]
let iconsetPath = "/tmp/UniJoyIcon.iconset"
let fm = FileManager.default
try? fm.removeItem(atPath: iconsetPath)
try! fm.createDirectory(atPath: iconsetPath, withIntermediateDirectories: true)

for size in sizes {
    let image = NSImage(size: NSSize(width: size, height: size))
    image.lockFocus()
    
    let rect = NSRect(x: 0, y: 0, width: size, height: size)
    let s = CGFloat(size)
    let cornerRadius = s * 0.22
    
    // Background gradient — warm vermilion
    let bgPath = NSBezierPath(roundedRect: rect, xRadius: cornerRadius, yRadius: cornerRadius)
    let gradient = NSGradient(
        colors: [
            NSColor(red: 0.82, green: 0.24, blue: 0.15, alpha: 1.0), // #D13D26
            NSColor(red: 0.70, green: 0.18, blue: 0.12, alpha: 1.0)  // darker
        ],
        atLocations: [0.0, 1.0],
        colorSpace: .deviceRGB
    )!
    gradient.draw(in: bgPath, angle: -45)
    
    // Subtle inner glow
    let glowColor = NSColor(white: 1.0, alpha: 0.08)
    glowColor.setStroke()
    let innerPath = NSBezierPath(roundedRect: rect.insetBy(dx: 1, dy: 1), xRadius: cornerRadius - 1, yRadius: cornerRadius - 1)
    innerPath.lineWidth = s * 0.015
    innerPath.stroke()
    
    // Draw "ক" character centered
    let fontSize = s * 0.52
    let font = NSFont.systemFont(ofSize: fontSize, weight: .bold)
    let text = "ক" as NSString
    let attrs: [NSAttributedString.Key: Any] = [
        .font: font,
        .foregroundColor: NSColor.white
    ]
    let textSize = text.size(withAttributes: attrs)
    let textX = (s - textSize.width) / 2
    let textY = (s - textSize.height) / 2 - s * 0.02
    text.draw(at: NSPoint(x: textX, y: textY), withAttributes: attrs)
    
    image.unlockFocus()
    
    // Save
    guard let tiff = image.tiffRepresentation,
          let bitmap = NSBitmapImageRep(data: tiff),
          let png = bitmap.representation(using: .png, properties: [:]) else { continue }
    
    let filename: String
    if size <= 512 {
        try! png.write(to: URL(fileURLWithPath: "\(iconsetPath)/icon_\(size)x\(size).png"))
        // Also write @2x for half sizes
        let halfSize = size / 2
        if halfSize >= 16 {
            try! png.write(to: URL(fileURLWithPath: "\(iconsetPath)/icon_\(halfSize)x\(halfSize)@2x.png"))
        }
    }
    if size == 1024 {
        try! png.write(to: URL(fileURLWithPath: "\(iconsetPath)/icon_512x512@2x.png"))
    }
}

print("✅ Iconset created at \(iconsetPath)")
