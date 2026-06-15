from PIL import Image, ImageDraw
import os

def create_raven_icon(size, filename):
    # Create image with gradient background (purple like Raven's hood)
    img = Image.new('RGB', (size, size), color='#4a1a6b')
    draw = ImageDraw.Draw(img)
    
    # Create gradient effect (purple to dark blue)
    for y in range(size):
        r = int(74 + (45 - 74) * y / size)
        g = int(26 + (15 - 26) * y / size)
        b = int(107 + (74 - 107) * y / size)
        draw.line([(0, y), (size, y)], fill=(r, g, b))
    
    # Draw Raven's hood - more pointed top
    center_x = size // 2
    center_y = size // 2
    hood_width = size // 2.5
    hood_height = size // 1.5
    
    # Hood main shape - pointed top like Raven's
    hood_top_y = center_y - hood_height // 2
    hood_bottom_y = center_y + hood_height // 3
    
    # Draw hood shape with pointed top
    draw.polygon([
        (center_x, hood_top_y),  # Pointed top
        (center_x - hood_width, center_y - hood_height // 4),
        (center_x - hood_width, hood_bottom_y),
        (center_x - hood_width // 3, hood_bottom_y + size // 10),
        (center_x - hood_width // 3, size - size // 20),
        (center_x + hood_width // 3, size - size // 20),
        (center_x + hood_width // 3, hood_bottom_y + size // 10),
        (center_x + hood_width, hood_bottom_y),
        (center_x + hood_width, center_y - hood_height // 4)
    ], fill='#5c2d8a', outline='#7b4397', width=max(2, size // 100))
    
    # Hood inner lighter area
    inner_hood_width = hood_width * 0.8
    draw.polygon([
        (center_x, hood_top_y + size // 20),
        (center_x - inner_hood_width, center_y - hood_height // 5),
        (center_x - inner_hood_width, hood_bottom_y - size // 20),
        (center_x - inner_hood_width // 3, hood_bottom_y + size // 15),
        (center_x - inner_hood_width // 3, size - size // 15),
        (center_x + inner_hood_width // 3, size - size // 15),
        (center_x + inner_hood_width // 3, hood_bottom_y + size // 15),
        (center_x + inner_hood_width, hood_bottom_y - size // 20),
        (center_x + inner_hood_width, center_y - hood_height // 5)
    ], fill='#5c2d8a')
    
    # Face opening - angular like Raven's
    face_width = hood_width * 0.5
    face_height = hood_height * 0.4
    draw.polygon([
        (center_x - face_width, center_y - face_height // 4),
        (center_x + face_width, center_y - face_height // 4),
        (center_x + face_width, center_y + face_height // 2),
        (center_x, center_y + face_height // 2 + size // 20),
        (center_x - face_width, center_y + face_height // 2)
    ], fill='#3a1252', outline='#2d0f4a', width=max(1, size // 200))
    
    # Red hair strands - more prominent and flowing
    hair_width = max(4, size // 25)
    # Left main strand
    draw.line([center_x - face_width, center_y + face_height // 2,
               center_x - hood_width, size - size // 15], 
              fill='#ff4444', width=hair_width)
    # Left secondary strand
    draw.line([center_x - face_width - size // 30, center_y + face_height // 2,
               center_x - hood_width - size // 20, size - size // 20], 
              fill='#cc3333', width=hair_width - 1)
    
    # Right main strand
    draw.line([center_x + face_width, center_y + face_height // 2,
               center_x + hood_width, size - size // 15], 
              fill='#ff4444', width=hair_width)
    # Right secondary strand
    draw.line([center_x + face_width + size // 30, center_y + face_height // 2,
               center_x + hood_width + size // 20, size - size // 20], 
              fill='#cc3333', width=hair_width - 1)
    
    # Hood rim detail
    draw.arc([center_x - face_width, center_y - face_height // 4,
              center_x + face_width, center_y + face_height // 2], 
             0, 180, fill='#7b4397', width=max(2, size // 80))
    
    # Hood side folds
    fold_x = center_x - hood_width * 0.6
    draw.line([fold_x, center_y - hood_height // 3, fold_x, center_y + face_height // 2], 
              fill='#3a1252', width=max(1, size // 150))
    fold_x = center_x + hood_width * 0.6
    draw.line([fold_x, center_y - hood_height // 3, fold_x, center_y + face_height // 2], 
              fill='#3a1252', width=max(1, size // 150))
    
    # Save the image
    img.save(filename, 'PNG')
    print(f'Created {filename} ({size}x{size})')

# Create icons
create_raven_icon(192, 'icon-192.png')
create_raven_icon(512, 'icon-512.png')

print('Raven-inspired icons generated successfully!')
