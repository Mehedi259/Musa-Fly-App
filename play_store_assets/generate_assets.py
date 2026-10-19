import os
from PIL import Image, ImageDraw, ImageFont, ImageFilter

ASSETS_DIR = "/Users/mehedihasanmridul/app/Musa-Fly-App/play_store_assets"
LOGO_PATH = "/Users/mehedihasanmridul/app/Musa-Fly-App/assets/images/logo.png"
MOCKUP_FLIGHTS = "/Users/mehedihasanmridul/.gemini/antigravity-ide/brain/ba2f5122-715d-4808-ba70-1b16521ce319/musafly_flight_search_ui_1792329991096.jpg"
MOCKUP_TOURS = "/Users/mehedihasanmridul/.gemini/antigravity-ide/brain/ba2f5122-715d-4808-ba70-1b16521ce319/musafly_tour_umrah_ui_1792330014316.jpg"
MOCKUP_VISA = "/Users/mehedihasanmridul/.gemini/antigravity-ide/brain/ba2f5122-715d-4808-ba70-1b16521ce319/musafly_visa_services_ui_1792330043386.jpg"

os.makedirs(ASSETS_DIR, exist_ok=True)

# 1. 512x512 App Icon
def create_app_icon():
    size = (512, 512)
    img = Image.new("RGBA", size, (255, 255, 255, 255))
    
    # Optional subtle gradient or soft border
    draw = ImageDraw.Draw(img)
    
    # Load logo
    if os.path.exists(LOGO_PATH):
        logo = Image.open(LOGO_PATH).convert("RGBA")
        # Resize logo keeping aspect ratio to fit inside 420x420
        target_w = 420
        ratio = target_w / float(logo.width)
        target_h = int(logo.height * ratio)
        if target_h > 420:
            ratio = 420 / float(logo.height)
            target_w = int(logo.width * ratio)
            target_h = 420
        logo = logo.resize((target_w, target_h), Image.Resampling.LANCZOS)
        
        pos_x = (512 - target_w) // 2
        pos_y = (512 - target_h) // 2
        img.paste(logo, (pos_x, pos_y), logo)
    
    out_path = os.path.join(ASSETS_DIR, "icon_512x512.png")
    img.save(out_path, "PNG")
    print(f"Created app icon: {out_path}")

# 2. 1024x500 Feature Graphic
def create_feature_graphic():
    width, height = 1024, 500
    # Create smooth gradient from dark navy to brand blue
    img = Image.new("RGBA", (width, height))
    draw = ImageDraw.Draw(img)
    
    # Vertical / slight diagonal gradient
    for y in range(height):
        # Gradient from #0D2137 (13, 33, 55) to #1A426F (26, 66, 111)
        factor = y / float(height)
        r = int(13 + factor * (26 - 13))
        g = int(33 + factor * (66 - 33))
        b = int(55 + factor * (111 - 55))
        draw.line([(0, y), (width, y)], fill=(r, g, b, 255))
    
    # Draw decorative circles/accents
    overlay = Image.new("RGBA", (width, height), (0, 0, 0, 0))
    ol_draw = ImageDraw.Draw(overlay)
    ol_draw.ellipse([700, -100, 1150, 350], fill=(91, 155, 213, 30))
    ol_draw.ellipse([800, 150, 1200, 550], fill=(244, 185, 66, 25))
    ol_draw.ellipse([-100, 200, 300, 600], fill=(91, 155, 213, 20))
    img = Image.alpha_composite(img, overlay)
    
    # Paste logo on the left or top-left
    if os.path.exists(LOGO_PATH):
        logo = Image.open(LOGO_PATH).convert("RGBA")
        target_w = 400
        target_h = int(logo.height * (target_w / float(logo.width)))
        logo = logo.resize((target_w, target_h), Image.Resampling.LANCZOS)
        
        # Add white background container for logo for pristine contrast
        pad_x = 20
        pad_y = 15
        box_w = target_w + pad_x * 2
        box_h = target_h + pad_y * 2
        card = Image.new("RGBA", (box_w, box_h), (255, 255, 255, 245))
        card_draw = ImageDraw.Draw(card)
        
        img.paste(card, (80, 100), card)
        img.paste(logo, (80 + pad_x, 100 + pad_y), logo)
    
    draw = ImageDraw.Draw(img)
    
    # Text badges on right side
    try:
        font_large = ImageFont.truetype("/System/Library/Fonts/Helvetica.ttc", 38)
        font_sub = ImageFont.truetype("/System/Library/Fonts/Helvetica.ttc", 22)
        font_badge = ImageFont.truetype("/System/Library/Fonts/Helvetica.ttc", 18)
    except Exception:
        font_large = ImageFont.load_default()
        font_sub = ImageFont.load_default()
        font_badge = ImageFont.load_default()
        
    draw.text((80, 270), "Your Premium Travel Partner", fill=(255, 255, 255, 255), font=font_large)
    draw.text((80, 330), "Cheap Flights • Curated Tours • Umrah Packages • Visa Services", fill=(200, 220, 245, 255), font=font_sub)
    
    # Badges row
    badges = ["✈ Flight Booking", "🕋 Umrah Packages", "🏝 Tour Packages", "📋 Visa Assistance"]
    bx = 80
    for b in badges:
        bw = len(b) * 11 + 24
        draw.rounded_rectangle([bx, 385, bx + bw, 425], radius=8, fill=(91, 155, 213, 60), outline=(244, 185, 66, 180), width=1)
        draw.text((bx + 12, 395), b, fill=(255, 255, 255), font=font_badge)
        bx += bw + 15
        
    out_path = os.path.join(ASSETS_DIR, "feature_graphic_1024x500.png")
    img.save(out_path, "PNG")
    print(f"Created feature graphic: {out_path}")

# 3. Phone Screenshots (1080 x 1920)
def create_screenshot(source_mockup, title, subtitle, output_name):
    width, height = 1080, 1920
    img = Image.new("RGBA", (width, height))
    draw = ImageDraw.Draw(img)
    
    # Background gradient
    for y in range(height):
        factor = y / float(height)
        r = int(15 + factor * (30 - 15))
        g = int(35 + factor * (70 - 35))
        b = int(60 + factor * (120 - 60))
        draw.line([(0, y), (width, y)], fill=(r, g, b, 255))
        
    try:
        font_title = ImageFont.truetype("/System/Library/Fonts/Helvetica.ttc", 60)
        font_sub = ImageFont.truetype("/System/Library/Fonts/Helvetica.ttc", 32)
    except Exception:
        font_title = ImageFont.load_default()
        font_sub = ImageFont.load_default()
        
    # Title & Subtitle centered at top
    bbox_t = draw.textbbox((0, 0), title, font=font_title)
    tw = bbox_t[2] - bbox_t[0]
    draw.text(((width - tw) // 2, 80), title, fill=(255, 255, 255, 255), font=font_title)
    
    bbox_s = draw.textbbox((0, 0), subtitle, font=font_sub)
    sw = bbox_s[2] - bbox_s[0]
    draw.text(((width - sw) // 2, 160), subtitle, fill=(244, 185, 66, 255), font=font_sub)
    
    # Phone frame mock
    if os.path.exists(source_mockup):
        screen = Image.open(source_mockup).convert("RGBA")
        target_w = 780
        target_h = int(screen.height * (target_w / float(screen.width)))
        if target_h > 1550:
            target_h = 1550
        screen = screen.resize((target_w, target_h), Image.Resampling.LANCZOS)
        
        # Phone border
        px = (width - target_w) // 2
        py = 240
        draw.rounded_rectangle([px - 10, py - 10, px + target_w + 10, py + target_h + 10], radius=30, fill=(30, 30, 30), outline=(91, 155, 213), width=4)
        img.paste(screen, (px, py))
        
    out_path = os.path.join(ASSETS_DIR, output_name)
    img.save(out_path, "PNG")
    print(f"Created screenshot: {out_path}")

create_app_icon()
create_feature_graphic()
create_screenshot(MOCKUP_FLIGHTS, "Search & Book Flights", "Best Fares & Instant Booking", "screenshot_1_flights.png")
create_screenshot(MOCKUP_TOURS, "Tours & Umrah Packages", "Curated Experiences & Group Trips", "screenshot_2_tours.png")
create_screenshot(MOCKUP_VISA, "Easy Visa Processing", "Fast, Reliable & Transparent", "screenshot_3_visa.png")
