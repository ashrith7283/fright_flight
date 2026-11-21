"""Generates Play Store listing art (run: python3 tool/make_store_assets.py).

Needs Pillow. Writes store/icon-512.png and store/feature-graphic-1024x500.png.
Reuses the plane and sky drawing from make_icon.py, so the art stays original.
"""
import os
import sys

from PIL import Image, ImageDraw, ImageFont

sys.path.insert(0, os.path.dirname(__file__))
import make_icon  # noqa: E402

FONTS = ["/System/Library/Fonts/Supplemental/Arial Rounded Bold.ttf",
         "/System/Library/Fonts/Supplemental/Arial Bold.ttf"]


def font(size: int) -> ImageFont.FreeTypeFont:
    for path in FONTS:
        if os.path.exists(path):
            return ImageFont.truetype(path, size)
    return ImageFont.load_default()


def cloud(d: ImageDraw.ImageDraw, x: float, y: float, w: float) -> None:
    """Soft lobed cloud: a flat base ellipse plus overlapping puffs."""
    h = w * 0.4
    d.ellipse([x, y + h * .45, x + w, y + h], fill=(255, 255, 255, 235))
    for dx, dy, r in [(.28, .5, .34), (.5, .28, .42), (.72, .5, .3)]:
        cx, cy, rr = x + dx * w, y + dy * h, r * h
        d.ellipse([cx - rr, cy - rr, cx + rr, cy + rr], fill=(255, 255, 255, 235))


def sky(w: int, h: int) -> Image.Image:
    img = Image.new("RGB", (w, h))
    d = ImageDraw.Draw(img)
    top, bottom = (38, 132, 214), (160, 214, 245)
    for y in range(h):
        t = y / (h - 1)
        d.line([(0, y), (w, y)], fill=tuple(round(top[i] + (bottom[i] - top[i]) * t) for i in range(3)))
    return img


def icon() -> None:
    Image.open("assets/icon/icon.png").resize((512, 512), Image.LANCZOS).save("store/icon-512.png")


def feature_graphic() -> None:
    w, h = 1024, 500
    img = sky(w, h).convert("RGBA")
    d = ImageDraw.Draw(img, "RGBA")
    d.ellipse([860, 30, 960, 130], fill=(255, 224, 120, 255))
    for x, y, cw in [(420, 20, 170), (560, 400, 230), (850, 330, 150), (90, 420, 190)]:
        cloud(d, x, y, cw)
    plane = make_icon.plane().resize((1024, 1024), Image.LANCZOS)
    plane = plane.crop((120, 250, 900, 800)).resize((500, 352), Image.LANCZOS)
    img.alpha_composite(plane, (480, 100))
    title, sub = font(92), font(34)
    for off, col in [((4, 5), (20, 50, 100, 120)), ((0, 0), (255, 255, 255, 255))]:
        d.text((50 + off[0], 90 + off[1]), "FRIGHT", font=title, fill=col)
        d.text((50 + off[0], 185 + off[1]), "FLIGHT", font=title, fill=col)
    d.text((54, 310), "One tap. Endless sky.", font=sub, fill=(255, 255, 255, 255))
    img.convert("RGB").save("store/feature-graphic-1024x500.png")


if __name__ == "__main__":
    os.makedirs("store", exist_ok=True)
    icon()
    feature_graphic()
