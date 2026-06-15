from PIL import Image, ImageDraw, ImageFont
import os

def create_icon(size, filename):
    # Create image with gradient background
    img = Image.new('RGB', (size, size), color='#667eea')
    draw = ImageDraw.Draw(img)
    
    # Create gradient effect
    for y in range(size):
        r = int(102 + (118 - 102) * y / size)
        g = int(126 + (75 - 126) * y / size)
        b = int(234 + (162 - 234) * y / size)
        draw.line([(0, y), (size, y)], fill=(r, g, b))
    
    # Draw a simple food icon (bowl shape)
    center_x = size // 2
    center_y = size // 2
    radius = size // 4
    
    # Bowl
    draw.ellipse([center_x - radius, center_y - radius//2, 
                  center_x + radius, center_y + radius//2], 
                 fill='white', outline='white', width=2)
    
    # Steam lines
    draw.line([center_x - radius//2, center_y - radius, 
               center_x - radius//2, center_y - radius - size//8], 
              fill='white', width=3)
    draw.line([center_x, center_y - radius - size//16, 
               center_x, center_y - radius - size//4], 
              fill='white', width=3)
    draw.line([center_x + radius//2, center_y - radius, 
               center_x + radius//2, center_y - radius - size//8], 
              fill='white', width=3)
    
    # Save the image
    img.save(filename, 'PNG')
    print(f'Created {filename} ({size}x{size})')

# Create icons
create_icon(192, 'icon-192.png')
create_icon(512, 'icon-512.png')

print('Icons generated successfully!')
