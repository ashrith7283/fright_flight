"""Generates the original launcher icon art (run: python3 tool/make_icon.py).

Needs Pillow. Writes assets/icon/{background,foreground,icon}.png (1024px).
The foreground is the plane only (flutter_launcher_icons insets it into the safe zone).
"""
from PIL import Image, ImageDraw

S = 1024
K = 4  # supersampling for smooth edges
N = S * K


def sky() -> Image.Image:
    img = Image.new("RGB", (N, N))
    px = img.load()
    top, bottom = (38, 132, 214), (160, 214, 245)
    for y in range(N):
        t = y / (N - 1)
        c = tuple(round(top[i] + (bottom[i] - top[i]) * t) for i in range(3))
        for x in range(N):
            px[x, y] = c
    d = ImageDraw.Draw(img, "RGBA")
    d.ellipse([N * 0.64, N * 0.12, N * 0.86, N * 0.34], fill=(255, 224, 120, 255))
    return img


def plane() -> Image.Image:
    img = Image.new("RGBA", (N, N), (0, 0, 0, 0))
    d = ImageDraw.Draw(img)
    # Fractions of the canvas, nudged up so the plane sits at the centre.
    p = lambda x, y: (x * N, (y - .04) * N)  # noqa: E731
    body, shade, red = (245, 247, 250, 255), (205, 213, 224, 255), (229, 57, 53, 255)
    # tail fin
    d.polygon([p(.25, .50), p(.20, .36), p(.31, .36), p(.38, .50)], fill=red)
    # tailplane
    d.polygon([p(.26, .52), p(.18, .54), p(.20, .58), p(.34, .56)], fill=shade)
    # fuselage with rounded nose
    d.rounded_rectangle([p(.20, .46), p(.80, .62)], radius=N * .08, fill=body)
    d.ellipse([p(.66, .46), p(.82, .62)], fill=body)
    # red stripe
    d.rectangle([p(.30, .565), p(.72, .585)], fill=red)
    # cockpit window
    d.rounded_rectangle([p(.58, .485), p(.69, .54)], radius=N * .02, fill=(70, 150, 220, 255))
    # wing
    d.polygon([p(.42, .56), p(.56, .56), p(.46, .72), p(.34, .72)], fill=shade)
    # propeller
    d.rounded_rectangle([p(.81, .42), p(.835, .66)], radius=N * .012, fill=(60, 70, 85, 255))
    return img


def main() -> None:
    bg, fg = sky(), plane()
    out = "assets/icon/"
    bg.resize((S, S), Image.LANCZOS).save(out + "background.png")
    fg.resize((S, S), Image.LANCZOS).save(out + "foreground.png")
    full = bg.convert("RGBA")
    full.alpha_composite(fg)
    full.resize((S, S), Image.LANCZOS).convert("RGB").save(out + "icon.png")


if __name__ == "__main__":
    main()
