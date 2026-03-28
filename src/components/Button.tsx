import type { ButtonHTMLAttributes, PropsWithChildren } from "react";

type ButtonVariant = "primary" | "secondary" | "ghost";

interface ButtonProps extends ButtonHTMLAttributes<HTMLButtonElement> {
  variant?: ButtonVariant;
  wide?: boolean;
}

export function Button({
  variant = "primary",
  wide = false,
  children,
  className,
  ...rest
}: PropsWithChildren<ButtonProps>) {
  return (
    <button
      className={[
        "action-button",
        `action-button--${variant}`,
        wide ? "action-button--wide" : "",
        className ?? "",
      ]
        .filter(Boolean)
        .join(" ")}
      {...rest}
    >
      {children}
    </button>
  );
}
