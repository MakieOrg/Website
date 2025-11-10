# Modern styles for Makie website using Bonito.Styles
# Replaces Tailwind CSS with custom modern styling

using Bonito

# Modern color palette - vibrant blue theme with better contrast
const MAKIE_COLORS = (
    # Primary brand colors
    primary = "#2196F3",           # Modern bright blue
    primary_dark = "#1565C0",      # Darker blue for hover/active states
    primary_light = "#E3F2FD",     # Very light blue for backgrounds

    # Neutrals - modern warm grays
    gray_50 = "#FAFAFA",
    gray_100 = "#F5F5F5",
    gray_200 = "#EEEEEE",
    gray_300 = "#E0E0E0",
    gray_600 = "#757575",

    # Text colors
    text_primary = "#212121",
    text_secondary = "#424242",

    # Link colors
    link = "#2196F3",
    link_visited = "#7E57C2",

    white = "#FFFFFF",
)

# Create the website stylesheet
function website_styles()
    return Styles(
        # === CSS VARIABLES ===
        CSS(":root",
            "--text-color" => MAKIE_COLORS.text_primary,
            "--text-secondary" => MAKIE_COLORS.text_secondary,
            "--background-color" => MAKIE_COLORS.primary,
            "--background-color-highlight" => "rgba(255, 255, 255, 0.2)",
            "--primary-dark" => MAKIE_COLORS.primary_dark,
            "--gray-light" => MAKIE_COLORS.gray_100,
        ),

        # === FONT FACE ===
        CSS("@font-face",
            "font-family" => "octicons-link",
            "src" => "url(data:font/woff;charset=utf-8;base64,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) format('woff')"
        ),

        # === BASE STYLES (Tailwind-style reset) ===
        CSS("*, ::before, ::after",
            "box-sizing" => "border-box",
            "border-width" => "0",
            "border-style" => "solid"
        ),

        CSS("body",
            "width" => "100%",
            "background-color" => "rgb(255, 255, 255)",
            "margin" => "0",
            "line-height" => "1.5",
            "font-family" => "-apple-system, BlinkMacSystemFont, 'Segoe UI', 'Roboto', 'Helvetica Neue', Arial, sans-serif, 'Apple Color Emoji', 'Segoe UI Emoji', 'Segoe UI Symbol'",
            "font-size" => "1rem",
            "color" => MAKIE_COLORS.text_primary
        ),

        # Tailwind image defaults
        CSS("img, video",
            "max-width" => "100%",
            "height" => "auto"
        ),

        CSS("img, svg, video, canvas, audio, iframe, embed, object",
            "display" => "block",
            "vertical-align" => "middle"
        ),

        # === MARKDOWN BODY ===
        CSS(".markdown-body",
            "margin" => "20px",
            "padding" => "20px",
            "color" => "var(--text-color)",
            "font-family" => "-apple-system, BlinkMacSystemFont, 'Roboto', 'Segoe UI', 'Helvetica Neue', 'Lucida Grande', Arial, sans-serif",
            "line-height" => "1.5"
        ),

        CSS("li p", "display" => "inline"),

        # Reset pre tag padding/margin from browser defaults
        CSS("pre",
            "padding" => "0",
            "margin" => "0"
        ),

        # === BLOG ENTRY STYLES ===
        CSS("div.blog_entry h3",
            "font-weight" => "700",
            "font-size" => "1.125rem",
            "line-height" => "1.75rem"
        ),

        CSS("div.blog_entry h4",
            "font-weight" => "500",
            "font-size" => "1rem",
            "line-height" => "1.6rem"
        ),

        CSS("div.blog_entry .date",
            "font-weight" => "400",
            "font-size" => "1rem",
            "line-height" => "1.6rem",
            "color" => "gray"
        ),

        # === ADMONITION STYLES ===
        CSS(".admonition",
            "border-radius" => "8px",
            "border-left" => "4px solid",
            "padding" => "16px 20px",
            "margin" => "16px 0",
            "font-family" => "-apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif",
            "line-height" => "1.5",
            "box-shadow" => "0 2px 4px rgba(0, 0, 0, 0.1)"
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

        # === TEXT UTILITY (for overlays) ===
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
        CSS(".grid-cols-2", "grid-template-columns" => "repeat(2, minmax(0, 1fr))"),
        CSS(".grid-cols-3", "grid-template-columns" => "repeat(3, minmax(0, 1fr))"),
        CSS(".grid-cols-4", "grid-template-columns" => "repeat(4, minmax(0, 1fr))"),

        # === SPACING ===

        # Padding
        CSS(".p-1", "padding" => "0.25rem"),
        CSS(".p-2", "padding" => "0.5rem"),
        CSS(".p-4", "padding" => "1rem"),
        CSS(".p-6", "padding" => "1.5rem"),
        CSS(".p-8", "padding" => "2rem"),
        CSS(".p-10", "padding" => "2.5rem"),

        CSS(".px-2", "padding-left" => "0.5rem", "padding-right" => "0.5rem"),
        CSS(".px-3", "padding-left" => "0.75rem", "padding-right" => "0.75rem"),
        CSS(".px-4", "padding-left" => "1rem", "padding-right" => "1rem"),
        CSS(".px-5", "padding-left" => "1.25rem", "padding-right" => "1.25rem"),

        CSS(".py-1", "padding-top" => "0.25rem", "padding-bottom" => "0.25rem"),
        CSS(".py-4", "padding-top" => "1rem", "padding-bottom" => "1rem"),

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
        CSS(".mt-4", "margin-top" => "1rem"),
        CSS(".mt-14", "margin-top" => "3.5rem"),
        CSS(".mb-10", "margin-bottom" => "2.5rem"),

        # === SIZING ===

        # Width
        CSS(".w-full", "width" => "100%"),
        CSS(".w-8", "width" => "2rem"),
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
        CSS(".max-w-5xl", "max-width" => "64rem"),
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
        CSS(".text-sm", "font-size" => "0.875rem", "line-height" => "1.25rem"),
        CSS(".text-base", "font-size" => "1rem", "line-height" => "1.5rem"),
        CSS(".text-lg", "font-size" => "1.125rem", "line-height" => "1.75rem"),
        CSS(".text-xl", "font-size" => "1.25rem", "line-height" => "1.75rem"),

        # Font weight
        CSS(".font-semibold", "font-weight" => "600"),
        CSS(".font-bold", "font-weight" => "700"),
        CSS(".font-black", "font-weight" => "900"),

        # Text alignment
        CSS(".text-left", "text-align" => "left"),
        CSS(".text-center", "text-align" => "center"),
        CSS(".text-justify", "text-align" => "justify"),

        # Text color
        CSS(".text-white", "color" => MAKIE_COLORS.white),
        CSS(".text-black", "color" => MAKIE_COLORS.text_primary),
        CSS(".text-blue-600", "color" => MAKIE_COLORS.link),
        CSS(".text-purple-600", "color" => MAKIE_COLORS.link_visited),
        CSS(".text-gray-600", "color" => MAKIE_COLORS.gray_600),

        # Visited link styling
        CSS(".visited\\:text-purple-600:visited", "color" => MAKIE_COLORS.link_visited),

        # Italic text
        CSS(".italic", "font-style" => "italic"),

        # === BACKGROUNDS ===

        CSS(".bg-white", "background-color" => MAKIE_COLORS.white),
        CSS(".bg-gray-100", "background-color" => MAKIE_COLORS.gray_100),
        CSS(".bg-gray-200", "background-color" => MAKIE_COLORS.gray_200),

        # === BORDERS AND SHADOWS ===

        CSS(".rounded-md", "border-radius" => "0.5rem"),
        CSS(".shadow",
            "box-shadow" => "0 2px 8px 0 rgba(0, 0, 0, 0.1)"
        ),

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

        # === COMPONENT STYLES ===

        # Base link styling - no underline
        CSS("a",
            "text-decoration" => "none"
        ),

        # Navbar - modern gradient
        CSS(".navbar",
            "background" => "linear-gradient(135deg, $(MAKIE_COLORS.primary) 0%, $(MAKIE_COLORS.primary_dark) 100%)",
            "box-shadow" => "0 2px 12px rgba(0, 0, 0, 0.15)"
        ),

        # Navbar links should have smooth transitions and good typography
        CSS(".navbar a",
            "text-decoration" => "none",
            "display" => "inline-block",
            "font-family" => "-apple-system, BlinkMacSystemFont, 'Segoe UI', 'Roboto', 'Helvetica Neue', Arial, sans-serif"
        ),

        # Navbar text styling
        CSS(".navbar",
            "font-size" => "0.9375rem",
            "font-weight" => "500"
        ),

        # Navbar highlight - applies to the inner div
        CSS(".navbar-highlight",
            "background-color" => "rgba(255, 255, 255, 0.2)",
            "border-radius" => "0.375rem",
            "transition" => "all 0.2s ease-in-out"
        ),

        # === CARD COMPONENT ===

        CSS(".card",
            "background-color" => MAKIE_COLORS.white,
            "border-radius" => "0.5rem",
            "padding" => "0.5rem 0.75rem",
            "box-shadow" => "0 2px 8px rgba(0, 0, 0, 0.08)",
            "transition" => "all 0.3s ease"
        ),

        CSS(".card:hover",
            "box-shadow" => "0 4px 16px rgba(0, 0, 0, 0.12)",
            "transform" => "translateY(-2px)"
        ),

        # === RESPONSIVE BREAKPOINTS ===

        CSS("@media (min-width: 640px)",
            CSS(".sm\\:flex-row", "flex-direction" => "row"),
            CSS(".sm\\:flex-row-reverse", "flex-direction" => "row-reverse"),
            CSS(".sm\\:grid-cols-2", "grid-template-columns" => "repeat(2, minmax(0, 1fr))"),
            CSS(".sm\\:grid-cols-3", "grid-template-columns" => "repeat(3, minmax(0, 1fr))"),
            CSS(".sm\\:w-1\\/3", "width" => "33.333333%"),
        ),

        CSS("@media (min-width: 768px)",
            CSS(".md\\:basis-2\\/5", "flex-basis" => "40%"),
            CSS(".md\\:basis-3\\/5", "flex-basis" => "60%"),
            CSS(".md\\:gap-10", "gap" => "2.5rem"),
            CSS(".md\\:grid-cols-4", "grid-template-columns" => "repeat(4, minmax(0, 1fr))"),
            CSS(".md\\:p-4", "padding" => "1rem"),
            CSS(".md\\:px-4", "padding-left" => "1rem", "padding-right" => "1rem"),
            CSS(".md\\:-m-4", "margin" => "-1rem"),
        ),

        CSS("@media (min-width: 1024px)",
            CSS(".lg\\:text-sm", "font-size" => "0.875rem", "line-height" => "1.25rem"),
            CSS(".lg\\:text-base", "font-size" => "1rem", "line-height" => "1.5rem"),
            CSS(".lg\\:w-1\\/5", "width" => "20%"),
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
            "padding" => "1rem"
        ),

        CSS(".container:hover .overlay",
            "background-color" => "rgba(255, 255, 255, 0.95)",
            "transition" => "color 0.5s ease-in 0.3s, background-color 0.3s ease-in",
            "visibility" => "visible",
            "color" => MAKIE_COLORS.text_primary
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
