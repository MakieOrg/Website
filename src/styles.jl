# Design system for the Makie website.
# Curated Styles: brand theme + components + a complete utility layer
# covering exactly the classes used in src/. Every utility class that
# appears in the sources must have a rule here, otherwise it silently
# does nothing (that was the source of many layout bugs).

using Bonito

# Makie brand palette (blue from the logo, slate neutrals)
const MAKIE_COLORS = (
    # Primary brand colors
    primary = "#3B5BDB",           # Makie blue
    primary_dark = "#2F4AC0",      # hover/active
    primary_light = "#EEF2FF",     # tint for backgrounds

    # Neutrals (slate)
    gray_50 = "#F8FAFC",
    gray_100 = "#F1F5F9",
    gray_200 = "#E2E8F0",
    gray_300 = "#CBD5E1",
    gray_500 = "#64748B",
    gray_600 = "#475569",

    # Text colors
    text_primary = "#0F172A",      # headings
    text_secondary = "#334155",    # body
    text_muted = "#64748B",        # captions, dates

    # Link colors
    link = "#3B5BDB",
    link_visited = "#3B5BDB",

    white = "#FFFFFF",
)

# Create the website stylesheet
function website_styles()
    return Styles(
        # === CSS VARIABLES ===
        CSS(":root",
            "--text-color" => MAKIE_COLORS.text_secondary,
            "--text-heading" => MAKIE_COLORS.text_primary,
            "--text-muted" => MAKIE_COLORS.text_muted,
            "--brand" => MAKIE_COLORS.primary,
            "--brand-dark" => MAKIE_COLORS.primary_dark,
            "--brand-light" => MAKIE_COLORS.primary_light,
            "--surface" => MAKIE_COLORS.gray_50,
            "--border" => MAKIE_COLORS.gray_200,
            "--background-color" => MAKIE_COLORS.primary,
            "--background-color-highlight" => "rgba(255, 255, 255, 0.2)",
            "--primary-dark" => MAKIE_COLORS.primary_dark,
            "--gray-light" => MAKIE_COLORS.gray_100,
            "--shadow-sm" => "0 1px 2px 0 rgba(15, 23, 42, 0.06)",
            "--shadow-md" => "0 4px 12px -2px rgba(15, 23, 42, 0.10)",
            "--shadow-lg" => "0 12px 32px -8px rgba(15, 23, 42, 0.15)",
        ),

        # === FONT FACE (anchor icon font for markdown) ===
        CSS("@font-face",
            "font-family" => "octicons-link",
            "src" => "url(data:font/woff;charset=utf-8;base64,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) format('woff')",
        ),

        # === BASE ===
        CSS("*, ::before, ::after",
            "box-sizing" => "border-box",
            "border-width" => "0",
            "border-style" => "solid"
        ),

        CSS("html",
            "scroll-behavior" => "smooth",
        ),

        CSS("body",
            "width" => "100%",
            "background-color" => "rgb(255, 255, 255)",
            "margin" => "0",
            "line-height" => "1.6",
            "font-family" => "ui-sans-serif, system-ui, -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif",
            "font-size" => "1rem",
            "color" => MAKIE_COLORS.text_secondary,
            "-webkit-font-smoothing" => "antialiased",
            "text-rendering" => "optimizeLegibility",
        ),

        CSS("img, video",
            "max-width" => "100%",
            "height" => "auto"
        ),

        CSS("img, svg, video, canvas, audio, iframe, embed, object",
            "display" => "block",
            "vertical-align" => "middle"
        ),

        # Base link styling
        CSS("a",
            "text-decoration" => "none",
            "color" => MAKIE_COLORS.link,
        ),

        # Paragraph spacing inside content flow
        CSS("p", "margin" => "0 0 0.75rem 0"),

        # === MARKDOWN BODY (blog posts) ===
        CSS(".markdown-body",
            "margin" => "20px",
            "padding" => "20px",
            "color" => "var(--text-color)",
            "font-family" => "ui-sans-serif, system-ui, -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif",
            "line-height" => "1.6"
        ),

        CSS("li p", "display" => "inline"),

        CSS("pre",
            "padding" => "0",
            "margin" => "0"
        ),

        # === BLOG ENTRY STYLES ===
        CSS("div.blog_entry",
            "padding" => "1rem",
            "display" => "flex",
            "flex-direction" => "column",
            "gap" => "0.375rem",
        ),

        CSS("div.blog_entry h3",
            "font-weight" => "700",
            "font-size" => "1.25rem",
            "line-height" => "1.4",
            "color" => MAKIE_COLORS.text_primary,
            "margin" => "0",
        ),

        CSS("div.blog_entry h4",
            "font-weight" => "400",
            "font-size" => "1rem",
            "line-height" => "1.5",
            "color" => MAKIE_COLORS.text_secondary,
            "margin" => "0",
        ),

        CSS("div.blog_entry p",
            "margin" => "0",
        ),

        CSS("div.blog_entry img, div.blog_entry video",
            "width" => "100%",
            "border-radius" => "0.5rem",
            "margin" => "0.25rem 0",
        ),

        CSS("div.blog_entry .date, .post-date",
            "font-weight" => "400",
            "font-size" => "0.875rem",
            "line-height" => "1.5",
            "color" => MAKIE_COLORS.text_muted
        ),

        CSS("a.blog_card:hover h3",
            "color" => MAKIE_COLORS.primary
        ),

        # === ADMONITION STYLES ===
        CSS(".admonition",
            "border-radius" => "8px",
            "border-left" => "4px solid",
            "padding" => "16px 20px",
            "margin" => "16px 0",
            "line-height" => "1.5",
            "box-shadow" => "var(--shadow-sm)"
        ),

        CSS(".admonition.warning",
            "background-color" => "#fff8e1",
            "border-left-color" => "#ff9800",
            "color" => "#e65100"
        ),

        CSS(".admonition .title",
            "font-weight" => "600",
            "font-size" => "1.1em",
            "margin" => "0 0 8px 0",
            "display" => "flex",
            "align-items" => "center",
            "color" => "#e65100"
        ),

        CSS(".admonition .title::before",
            "content" => "'⚠️'",
            "margin-right" => "8px",
            "font-size" => "1.2em"
        ),

        CSS(".admonition p:not(.title)",
            "margin" => "0",
            "color" => "#bf360c"
        ),

        CSS(".admonition.info",
            "background-color" => "#e3f2fd",
            "border-left-color" => "#2196f3",
            "color" => "#0d47a1"
        ),

        # === MAKIE BLUE (legacy) ===
        CSS(".makie-blue", "background-color" => "#8398a7"),

        # === TEXT (for overlays) ===
        CSS(".text",
            "white-space" => "nowrap",
            "color" => "rgb(48, 48, 48)",
            "font-size" => "20px",
            "position" => "absolute",
            "overflow" => "hidden"
        ),

        # === LAYOUT UTILITIES ===

        # Display
        CSS(".flex", "display" => "flex"),
        CSS(".grid", "display" => "grid"),
        CSS(".block", "display" => "block"),
        CSS(".inline-block", "display" => "inline-block"),

        # Flex direction
        CSS(".flex-row", "flex-direction" => "row"),
        CSS(".flex-col", "flex-direction" => "column"),
        CSS(".flex-row-reverse", "flex-direction" => "row-reverse"),
        CSS(".flex-wrap", "flex-wrap" => "wrap"),

        # Justify & Align
        CSS(".justify-center", "justify-content" => "center"),
        CSS(".items-center", "align-items" => "center"),
        CSS(".items-start", "align-items" => "flex-start"),

        # Gap utilities
        CSS(".gap-1", "gap" => "0.25rem"),
        CSS(".gap-2", "gap" => "0.5rem"),
        CSS(".gap-3", "gap" => "0.75rem"),
        CSS(".gap-4", "gap" => "1rem"),
        CSS(".gap-5", "gap" => "1.25rem"),
        CSS(".gap-6", "gap" => "1.5rem"),
        CSS(".gap-8", "gap" => "2rem"),
        CSS(".gap-10", "gap" => "2.5rem"),

        # Grid columns
        CSS(".grid-cols-1", "grid-template-columns" => "repeat(1, minmax(0, 1fr))"),
        CSS(".grid-cols-2", "grid-template-columns" => "repeat(2, minmax(0, 1fr))"),
        CSS(".grid-cols-3", "grid-template-columns" => "repeat(3, minmax(0, 1fr))"),
        CSS(".grid-cols-4", "grid-template-columns" => "repeat(4, minmax(0, 1fr))"),

        # === SPACING ===

        # Padding
        CSS(".p-1", "padding" => "0.25rem"),
        CSS(".p-2", "padding" => "0.5rem"),
        CSS(".p-3", "padding" => "0.75rem"),
        CSS(".p-4", "padding" => "1rem"),
        CSS(".p-6", "padding" => "1.5rem"),
        CSS(".p-8", "padding" => "2rem"),
        CSS(".p-10", "padding" => "2.5rem"),

        CSS(".px-2", "padding-left" => "0.5rem", "padding-right" => "0.5rem"),
        CSS(".px-3", "padding-left" => "0.75rem", "padding-right" => "0.75rem"),
        CSS(".px-4", "padding-left" => "1rem", "padding-right" => "1rem"),
        CSS(".px-5", "padding-left" => "1.25rem", "padding-right" => "1.25rem"),
        CSS(".px-6", "padding-left" => "1.5rem", "padding-right" => "1.5rem"),

        CSS(".py-1", "padding-top" => "0.25rem", "padding-bottom" => "0.25rem"),
        CSS(".py-2", "padding-top" => "0.5rem", "padding-bottom" => "0.5rem"),
        CSS(".py-3", "padding-top" => "0.75rem", "padding-bottom" => "0.75rem"),
        CSS(".py-4", "padding-top" => "1rem", "padding-bottom" => "1rem"),
        CSS(".py-6", "padding-top" => "1.5rem", "padding-bottom" => "1.5rem"),
        CSS(".py-8", "padding-top" => "2rem", "padding-bottom" => "2rem"),

        # Margin
        CSS(".m-0", "margin" => "0"),
        CSS(".m-1", "margin" => "0.25rem"),
        CSS(".m-2", "margin" => "0.5rem"),
        CSS(".m-4", "margin" => "1rem"),
        CSS(".-m-2", "margin" => "-0.5rem"),
        CSS(".-m-4", "margin" => "-1rem"),
        CSS(".-m-8", "margin" => "-2rem"),

        CSS(".mx-auto", "margin-left" => "auto", "margin-right" => "auto"),

        CSS(".my-1", "margin-top" => "0.25rem", "margin-bottom" => "0.25rem"),
        CSS(".my-3", "margin-top" => "0.75rem", "margin-bottom" => "0.75rem"),
        CSS(".my-4", "margin-top" => "1rem", "margin-bottom" => "1rem"),
        CSS(".my-6", "margin-top" => "1.5rem", "margin-bottom" => "1.5rem"),
        CSS(".my-10", "margin-top" => "2.5rem", "margin-bottom" => "2.5rem"),
        CSS(".my-14", "margin-top" => "3.5rem", "margin-bottom" => "3.5rem"),

        CSS(".mt-1", "margin-top" => "0.25rem"),
        CSS(".mt-2", "margin-top" => "0.5rem"),
        CSS(".mt-4", "margin-top" => "1rem"),
        CSS(".mt-14", "margin-top" => "3.5rem"),
        CSS(".mb-10", "margin-bottom" => "2.5rem"),

        # === SIZING ===

        # Width
        CSS(".w-full", "width" => "100%"),
        CSS(".w-8", "width" => "2rem"),
        CSS(".w-10", "width" => "2.5rem"),
        CSS(".w-1\\/2", "width" => "50%"),
        CSS(".w-1\\/3", "width" => "33.333333%"),
        CSS(".w-1\\/5", "width" => "20%"),
        CSS(".w-2\\/5", "width" => "40%"),
        CSS(".w-3\\/5", "width" => "60%"),
        CSS(".w-96", "width" => "24rem"),

        # Object fit for images
        CSS(".object-cover", "object-fit" => "cover"),
        CSS(".object-contain", "object-fit" => "contain"),

        # Max width
        CSS(".max-w-prose", "max-width" => "65ch"),
        CSS(".max-w-xl", "max-width" => "36rem"),
        CSS(".max-w-2xl", "max-width" => "42rem"),
        CSS(".max-w-5xl", "max-width" => "64rem"),
        CSS(".max-w-6xl", "max-width" => "72rem"),
        CSS(".max-w-full", "max-width" => "100%"),

        # Basis
        CSS(".basis-2\\/5", "flex-basis" => "40%"),
        CSS(".basis-3\\/5", "flex-basis" => "60%"),

        # Flex properties
        CSS(".grow", "flex-grow" => "1"),
        CSS(".flex-shrink-0", "flex-shrink" => "0"),
        CSS(".flex-1", "flex" => "1 1 0%"),

        # === TYPOGRAPHY ===

        # Font size
        CSS(".text-xs", "font-size" => "0.75rem", "line-height" => "1rem"),
        CSS(".text-sm", "font-size" => "0.875rem", "line-height" => "1.4"),
        CSS(".text-base", "font-size" => "1rem", "line-height" => "1.6"),
        CSS(".text-lg", "font-size" => "1.125rem", "line-height" => "1.65"),
        CSS(".text-xl", "font-size" => "1.25rem", "line-height" => "1.5"),
        CSS(".text-2xl", "font-size" => "1.5rem", "line-height" => "1.3"),
        CSS(".text-3xl", "font-size" => "1.875rem", "line-height" => "1.25"),
        CSS(".text-4xl", "font-size" => "2.25rem", "line-height" => "1.15"),

        # Font weight
        CSS(".font-semibold", "font-weight" => "600"),
        CSS(".font-bold", "font-weight" => "700"),
        CSS(".font-black", "font-weight" => "900"),

        # Letter spacing
        CSS(".tracking-tight", "letter-spacing" => "-0.02em"),

        # Text alignment
        CSS(".text-left", "text-align" => "left"),
        CSS(".text-center", "text-align" => "center"),
        CSS(".text-justify", "text-align" => "justify"),

        # Text color
        CSS(".text-white", "color" => MAKIE_COLORS.white),
        CSS(".text-black", "color" => MAKIE_COLORS.text_primary),
        CSS(".text-blue-600", "color" => MAKIE_COLORS.link),
        CSS(".text-purple-600", "color" => MAKIE_COLORS.link_visited),
        CSS(".text-gray-500", "color" => MAKIE_COLORS.text_muted),
        CSS(".text-gray-600", "color" => MAKIE_COLORS.gray_600),

        # Visited link styling
        CSS(".visited\\:text-purple-600:visited", "color" => MAKIE_COLORS.link_visited),

        # Italic text
        CSS(".italic", "font-style" => "italic"),

        # === LISTS ===
        CSS(".list-disc", "list-style-type" => "disc"),
        CSS(".list-inside", "list-style-position" => "inside"),
        CSS(".list-disc li + li", "margin-top" => "0.375rem"),

        # === BACKGROUNDS ===

        CSS(".bg-white", "background-color" => MAKIE_COLORS.white),
        CSS(".bg-gray-50", "background-color" => MAKIE_COLORS.gray_50),
        CSS(".bg-gray-100", "background-color" => MAKIE_COLORS.gray_100),
        CSS(".bg-gray-200", "background-color" => MAKIE_COLORS.gray_200),

        # === BORDERS AND SHADOWS ===

        CSS(".rounded-md", "border-radius" => "0.5rem"),
        CSS(".rounded-lg", "border-radius" => "0.625rem"),
        CSS(".rounded-xl", "border-radius" => "0.875rem"),
        CSS(".rounded-full", "border-radius" => "9999px"),

        CSS(".border", "border-width" => "1px", "border-color" => MAKIE_COLORS.gray_200),

        CSS(".shadow-sm", "box-shadow" => "var(--shadow-sm)"),
        CSS(".shadow", "box-shadow" => "var(--shadow-md)"),
        CSS(".shadow-lg", "box-shadow" => "var(--shadow-lg)"),

        # === EFFECTS ===

        CSS(".cursor-pointer", "cursor" => "pointer"),

        CSS(".hover\\:opacity-50:hover",
            "opacity" => "0.5",
            "transition" => "opacity 0.2s ease-in-out"
        ),

        CSS(".hover\\:bg-gray-300:hover",
            "background-color" => MAKIE_COLORS.gray_300,
            "transition" => "background-color 0.2s ease-in-out"
        ),

        CSS(".hover\\:underline:hover",
            "text-decoration" => "underline"
        ),

        # Sponsor/user logos: muted until hovered
        CSS(".logo-img",
            "filter" => "grayscale(1)",
            "opacity" => "0.65",
            "transition" => "filter 0.2s ease-in-out, opacity 0.2s ease-in-out"
        ),

        CSS(".logo-img:hover",
            "filter" => "grayscale(0)",
            "opacity" => "1"
        ),

        CSS(".quote-card",
            "transition" => "border-color 0.2s ease-in-out, box-shadow 0.2s ease-in-out"
        ),

        CSS(".quote-card:hover",
            "border-color" => MAKIE_COLORS.primary,
            "box-shadow" => "var(--shadow-sm)"
        ),

        # === COMPONENT STYLES ===

        # Sticky top navigation
        CSS(".navbar",
            "position" => "sticky",
            "top" => "0",
            "z-index" => "50",
            "background-color" => "rgba(255, 255, 255, 0.88)",
            "backdrop-filter" => "blur(10px)",
            "-webkit-backdrop-filter" => "blur(10px)",
            "border-bottom" => "1px solid var(--border)",
            "font-size" => "0.9375rem",
            "font-weight" => "500",
        ),

        CSS(".navbar a",
            "text-decoration" => "none",
            "display" => "inline-block",
            "color" => MAKIE_COLORS.text_secondary,
            "transition" => "color 0.15s ease-in-out",
        ),

        CSS(".navbar a:hover",
            "color" => MAKIE_COLORS.primary,
        ),

        # Active page in the navbar
        CSS(".navbar-highlight",
            "color" => MAKIE_COLORS.primary * " !important",
            "font-weight" => "600",
        ),

        # Desktop links: hidden on small screens
        CSS(".nav-desktop", "display" => "none"),
        CSS("@media (min-width: 768px)",
            CSS(".nav-desktop", "display" => "flex"),
            CSS(".nav-mobile", "display" => "none"),
        ),

        # Mobile hamburger (pure CSS toggle via details/summary)
        CSS(".nav-mobile", "position" => "relative"),
        CSS(".nav-mobile summary",
            "list-style" => "none",
            "cursor" => "pointer",
            "padding" => "0.375rem 0.625rem",
            "border-radius" => "0.5rem",
            "font-size" => "1.375rem",
            "line-height" => "1",
            "color" => MAKIE_COLORS.text_primary,
        ),
        CSS(".nav-mobile summary::-webkit-details-marker", "display" => "none"),
        CSS(".nav-mobile summary:hover", "background-color" => MAKIE_COLORS.gray_100),
        CSS(".nav-menu",
            "position" => "absolute",
            "right" => "0",
            "top" => "calc(100% + 0.5rem)",
            "background-color" => MAKIE_COLORS.white,
            "border" => "1px solid var(--border)",
            "border-radius" => "0.75rem",
            "box-shadow" => "var(--shadow-lg)",
            "padding" => "0.375rem",
            "display" => "flex",
            "flex-direction" => "column",
            "min-width" => "11rem",
            "z-index" => "60",
        ),
        CSS(".nav-menu a",
            "padding" => "0.5rem 0.75rem",
            "border-radius" => "0.5rem",
            "color" => MAKIE_COLORS.text_secondary,
        ),
        CSS(".nav-menu a:hover",
            "background-color" => MAKIE_COLORS.gray_100,
            "color" => MAKIE_COLORS.primary,
        ),

        # === CARD COMPONENT ===

        CSS(".card",
            "background-color" => MAKIE_COLORS.white,
            "border" => "1px solid var(--border)",
            "border-radius" => "0.875rem",
            "box-shadow" => "var(--shadow-sm)",
            "transition" => "box-shadow 0.2s ease, transform 0.2s ease, border-color 0.2s ease"
        ),

        CSS(".card:hover",
            "box-shadow" => "var(--shadow-md)",
            "transform" => "translateY(-2px)"
        ),

        # === BUTTONS ===

        CSS(".btn",
            "display" => "inline-block",
            "padding" => "0.625rem 1.25rem",
            "border-radius" => "0.625rem",
            "font-weight" => "600",
            "font-size" => "0.9375rem",
            "line-height" => "1.4",
            "transition" => "all 0.15s ease-in-out",
            "cursor" => "pointer",
        ),

        CSS(".btn-primary",
            "background-color" => MAKIE_COLORS.primary,
            "color" => MAKIE_COLORS.white * " !important",
            "box-shadow" => "var(--shadow-sm)",
        ),

        CSS(".btn-primary:hover",
            "background-color" => MAKIE_COLORS.primary_dark,
        ),

        CSS(".btn-outline",
            "border" => "1px solid var(--border)",
            "color" => MAKIE_COLORS.text_primary * " !important",
            "background-color" => MAKIE_COLORS.white,
        ),

        CSS(".btn-outline:hover",
            "border-color" => MAKIE_COLORS.primary,
            "color" => MAKIE_COLORS.primary * " !important",
        ),

        # === RESPONSIVE BREAKPOINTS ===

        CSS("@media (min-width: 640px)",
            CSS(".sm\\:flex-row", "flex-direction" => "row"),
            CSS(".sm\\:flex-row-reverse", "flex-direction" => "row-reverse"),
            CSS(".sm\\:grid-cols-2", "grid-template-columns" => "repeat(2, minmax(0, 1fr))"),
            CSS(".sm\\:grid-cols-3", "grid-template-columns" => "repeat(3, minmax(0, 1fr))"),
            CSS(".sm\\:w-1\\/3", "width" => "33.333333%"),
            CSS(".sm\\:p-8", "padding" => "2rem"),
            CSS("div.blog_entry", "padding" => "1.5rem"),
        ),

        CSS("@media (min-width: 768px)",
            CSS(".md\\:basis-2\\/5", "flex-basis" => "40%"),
            CSS(".md\\:basis-3\\/5", "flex-basis" => "60%"),
            CSS(".md\\:gap-10", "gap" => "2.5rem"),
            CSS(".md\\:grid-cols-2", "grid-template-columns" => "repeat(2, minmax(0, 1fr))"),
            CSS(".md\\:grid-cols-4", "grid-template-columns" => "repeat(4, minmax(0, 1fr))"),
            CSS(".md\\:p-4", "padding" => "1rem"),
            CSS(".md\\:px-4", "padding-left" => "1rem", "padding-right" => "1rem"),
            CSS(".md\\:-m-4", "margin" => "-1rem"),
        ),

        CSS("@media (min-width: 1024px)",
            CSS(".lg\\:text-sm", "font-size" => "0.875rem", "line-height" => "1.4"),
            CSS(".lg\\:text-base", "font-size" => "1rem", "line-height" => "1.6"),
            CSS(".lg\\:w-1\\/5", "width" => "20%"),
            CSS(".lg\\:w-1\\/3", "width" => "33.333333%"),
            CSS(".lg\\:grid-cols-3", "grid-template-columns" => "repeat(3, minmax(0, 1fr))"),
            CSS(".lg\\:p-8", "padding" => "2rem"),
            CSS(".lg\\:-m-8", "margin" => "-2rem"),
        ),

        # === CONTAINER OVERLAY (for DetailedCard) ===

        CSS(".container",
            "position" => "relative"
        ),

        CSS(".overlay",
            "position" => "absolute",
            "bottom" => "0",
            "left" => "0",
            "right" => "0",
            "background-color" => "#ffffff00",
            "overflow" => "hidden",
            "width" => "100%",
            "height" => "100%",
            "visibility" => "hidden",
            "color" => "transparent",
            "transition" => "color 0.3s ease-in, background-color 0.3s ease-in 0.3s",
            "display" => "flex",
            "align-items" => "center",
            "justify-content" => "center",
            "padding" => "1rem",
            "border-radius" => "0.875rem",
        ),

        CSS(".container:hover .overlay",
            "background-color" => "rgba(255, 255, 255, 0.95)",
            "transition" => "color 0.5s ease-in 0.3s, background-color 0.3s ease-in",
            "visibility" => "visible",
            "color" => MAKIE_COLORS.text_secondary
        ),

        CSS(".image",
            "max-height" => "none",
            "max-width" => "none"
        ),

        CSS(".container:hover .image",
            "filter" => "blur(4px)"
        ),
    )
end

# Export the styles
export website_styles, MAKIE_COLORS
